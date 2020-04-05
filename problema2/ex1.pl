%Descricao do problema:
/*
    Dando um estado inicial [XI,YI], tenta ir para um estado final [XF, YF]
    tendo em conta as restrições impostas, i.e. as trancições entre estados
    que não pode efetuar.
*/

:- dynamic(fechado/4).
:- dynamic(tamanho/1).
:- dynamic(estado_inicial/1).
:- dynamic(estado_final/1).

criar_fecho([]).
criar_fecho([[X,Y,X1,Y1]|T]):-
    asserta(fechado(X,Y,X1,Y1)),
    asserta(fechado(X1,Y1,X,Y)),
    criar_fecho(T).

pesquisa(R,T,Ei,Ef):-
    criar_fecho(R),
    asserta(tamanho(T)),
    asserta(estado_inicial(Ei)),
    asserta(estado_final(Ef)),
    pesquisa.

%Estados representados por listas [X,Y].

%estado_inicial(Estado)
estado_inicial([1,1]).

%estado_final(Estado)
estado_final([1,4]).

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
tamanho(4).

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

op([X,Y], direita, [X,Y1], 1) :-
    tamanho(T),
    Y < T,
    Y1 is Y + 1,
    \+ fechado(X,Y,X,Y1).

op([X,Y], esquerda, [X,Y1], 1) :-
    Y > 1,
    Y1 is Y - 1,
    \+ fechado(X,Y,X,Y1).

op([X,Y], baixo, [X1,Y], 1) :-
    tamanho(T),
    X < T,
    X1 is X + 1,
    \+ fechado(X,Y,X1,Y).

%representacao dos nos
%no(Estado,no_pai,Operador,Custo,Heuristica,Profundidade)
heur([X,Y], 0) :- estado_final([X,Y]).
heur([X,Y], 3) :- estado_inicial([X,Y]).
heur([X,Y], 1) :- tamanho(T), X > 1, X < T, Y > 1, Y < T.
%heur([_,_], 1).
heur([T,_], 2) :- tamanho(T).
heur([_,T], 2) :- tamanho(T).
heur([1,_], 2).
heur([_,1], 2).

pesquisa_local_hill_climbingSemCiclos(E, _,T) :-
    estado_final(E),
    write(E), write(' '),nl,write("Tamanho: "),write(T).

pesquisa_local_hill_climbingSemCiclos(E, L,T) :-
    write(E), write(' '),
    expande(E,LSeg),
    sort(3, @=<, LSeg, LOrd),
    obtem_no(LOrd, no(ES, Op, _)),
    \+ member(ES, L),
    write(Op), nl,
    T1 is T+1,
    (pesquisa_local_hill_climbingSemCiclos(ES,[E|L],T1) ; write(undo(Op)), write(' '), fail).

expande(E, L):-
    findall(no(En,Opn, Heur),
                (op(E,Opn,En,_), heur(En, Heur)),
                L).

obtem_no([H|_], H).
obtem_no([_|T], H1) :-
    obtem_no(T, H1).

pesquisa :-
    estado_inicial(S0),
    pesquisa_local_hill_climbingSemCiclos(S0, [],0).
