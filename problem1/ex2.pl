%Descricao do problema:
/*
    Dando um estado inicial [XI,YI], tenta ir para um estado final [XF, YF]
    tendo em conta as restrições impostas, i.e. as trancições entre estados
    que não pode efetuar.
*/

:- dynamic(fechado/4).
:- dynamic(tamanhoX/1).
:- dynamic(tamanhoY/1).
:- dynamic(estado_inicial/1).
:- dynamic(estado_final/1).

criar_fecho([]).
criar_fecho([[X,Y,X1,Y1]|T]):-
    asserta(fechado(X,Y,X1,Y1)),
    asserta(fechado(X1,Y1,X,Y)),
    criar_fecho(T).

pesquisa(R,Tx,Ty,Ei,Ef):-
    criar_fecho(R),
    asserta(tamanhoX(Tx)),
    asserta(tamanhoY(Ty)),
    asserta(estado_inicial(Ei)),
    asserta(estado_final(Ef)),
    pesquisa.

%Estados representados por listas [X,Y].

%estado_inicial(Estado)
estado_inicial([1,1]).

%estado_final(Estado)
estado_final([4,4]).

%restricoes
%fechado(X_Atual,Y_Atual,X_Destino,Y_Destino)
fechado(1,1,1,2).
fechado(1,2,1,1).

fechado(2,1,2,2).
fechado(2,2,2,1).

fechado(3,1,4,1).
fechado(4,1,3,1).

fechado(3,2,3,3).
fechado(3,3,3,2).

fechado(4,2,4,3).
fechado(4,3,4,2).

%tamanho_tabela
tamanhoX(4).
tamanhoY(4).

%representacao dos operadores
%op(Eact,OP,Eseg,Custo)

/*
    Para todos os predicados op/4.

    Verifica se está nos limites do tabuleiro,
    e se a transição entre Eact e o Eseg é possível.
*/

op([X,Y], cima, [X1,Y], 1) :-
    X > 1,
    X1 is X - 1,
    \+ fechado(X,Y,X1,Y).

op([X,Y], baixo, [X1,Y], 1) :-
    tamanhoX(T),
    X < T,
    X1 is X + 1,
    \+ fechado(X,Y,X1,Y).

op([X,Y], esquerda, [X,Y1], 1) :-
    Y > 1,
    Y1 is Y - 1,
    \+ fechado(X,Y,X,Y1).

op([X,Y], direita, [X,Y1], 1) :-
    tamanhoY(T),
    Y < T,
    Y1 is Y + 1,
    \+ fechado(X,Y,X,Y1).

%representacao dos nos
%no(Estado,no_pai,Operador,Custo,Heuristica,Profundidade)
absoluto(X,X) :- X >= 0, !.
absoluto(X,Y) :- X < 0, Y is -X.

heuristica([XInicial, YInicial] , H):- estado_final([XFinal, YFinal]),
    X is XFinal-XInicial, absoluto(X, XCalculado),
    Y is YFinal-YInicial, absoluto(Y, YCalculado),
    H is XCalculado+YCalculado.


pesquisa_aux([no(E,Pai,Op,C,H,P)|_],no(E,Pai,Op,C,H,P)) :-
	estado_final(E).
pesquisa_aux([E|R],Sol):-
    %length(R,Tamanhao),
    %write(Tamanhao),nl,
	expande(E,Lseg),
        insere_ordenado(Lseg,R,LFinal),
        pesquisa_aux(LFinal,Sol).

expande(no(E,Pai,Op,C,H,P),L):-
	findall(no(En,no(E,Pai,Op,C,H,P), Opn, Cnn, H1, P1),
                (op(E,Opn,En,Cn),
                     P1 is P+1,
                     Cnn is Cn+C,
                     heuristica(En,HCalculada),
                     H1 is Cnn + HCalculada),
                L).

pesquisa :-
	estado_inicial(S0),
	pesquisa_aux([no(S0,[],[],0,0,0)], S),
	write(S), nl.


ins_ord(E, [], [E]).
ins_ord(no(E,Pai,Op,C,Heur,P), [no(E1,Pai1,Op1,C1,Heur1,P1)|T], [no(E,Pai,Op,C,Heur,P),no(E1,Pai1,Op1,C1,Heur1,P1)|T]) :-
    Heur =< Heur1.
ins_ord(no(E,Pai,Op,C,Heur,P), [no(E1,Pai1,Op1,C1,Heur1,P1)|T], [no(E1,Pai1,Op1,C1,Heur1,P1)|T1]) :-
	ins_ord(no(E,Pai,Op,C,Heur,P), T, T1).

insere_ordenado([],L,L).
insere_ordenado([A|T], L, LF):-
	ins_ord(A,L,L1),
	insere_ordenado(T, L1, LF).
