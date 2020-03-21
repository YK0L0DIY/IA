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
%no(Estado,no_pai,Operador,Custo,Profundidade)

pesquisa_largura([no(E,Pai,Op,C,P)|_],no(E,Pai,Op,C,P)) :-
	estado_final(E).
pesquisa_largura([E|R],Sol):-
	expande(E,Lseg),
        insere_fim(Lseg,R,LFinal),
        pesquisa_largura(LFinal,Sol).

expande(no(E,Pai,Op,C,P),L):-
	findall(no(En,no(E,Pai,Op,C,P), Opn, Cnn, P1),
                (op(E,Opn,En,Cn), P1 is P+1, Cnn is Cn+C),
                L).

pesquisa :-
	estado_inicial(S0),
	pesquisa_largura([no(S0,[],[],0,0)], S),
	write(S), nl.


insere_fim([],L,L).
insere_fim(L,[],L).
insere_fim(R,[A|S],[A|L]):- insere_fim(R,S,L).
