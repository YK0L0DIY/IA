% cada posicao pode ter "x", "o" ou "v" (vazio)
estado_inicial([[x,v,v,v,v],[o,o,v,v,v],[x,o,x,v,v],[o,x,x,o,v]]).
%estado_inicial([[v,v,v],[v,v,v],[v,v,v]]).

terminal(G) :- linhas(G,_).
terminal(G) :- colunas(G,_).
terminal(G) :- diagonal(G,_).
terminal(G) :- cheio(G).

linhas([[X,X,X,_,_],_,_,_],X) :- X \= v.
linhas([[_,X,X,X,_],_,_,_],X) :- X \= v.
linhas([[_,_,X,X,X],_,_,_],X) :- X \= v.

linhas([_,[X,X,X,_,_],_,_],X) :- X \= v.
linhas([_,[_,X,X,X,_],_,_],X) :- X \= v.
linhas([_,[_,_,X,X,X],_,_],X) :- X \= v.

linhas([_,_,[X,X,X,_,_],_],X) :- X \= v.
linhas([_,_,[_,X,X,X,_],_],X) :- X \= v.
linhas([_,_,[_,_,X,X,X],_],X) :- X \= v.

linhas([_,_,_,[X,X,X,_,_]],X) :- X \= v.
linhas([_,_,_,[_,X,X,X,_]],X) :- X \= v.
linhas([_,_,_,[_,_,X,X,X]],X) :- X \= v.

colunas([[X,_,_,_,_],[X,_,_,_,_],[X,_,_,_,_], [_,_,_,_,_]],X) :- X \= v.
colunas([[_,_,_,_,_],[X,_,_,_,_],[X,_,_,_,_], [X,_,_,_,_]],X) :- X \= v.

colunas([[_,X,_,_,_],[_,X,_,_,_],[_,X,_,_,_], [_,_,_,_,_]],X) :- X \= v.
colunas([[_,_,_,_,_],[_,X,_,_,_],[_,X,_,_,_], [_,X,_,_,_]],X) :- X \= v.

colunas([[_,_,X,_,_],[_,_,X,_,_],[_,_,X,_,_], [_,_,_,_,_]],X) :- X \= v.
colunas([[_,_,_,_,_],[_,_,X,_,_],[_,_,X,_,_], [_,_,X,_,_]],X) :- X \= v.

colunas([[_,_,_,X,_],[_,_,_,X,_],[_,_,_,X,_], [_,_,_,_,_]],X) :- X \= v.
colunas([[_,_,_,_,_],[_,_,_,X,_],[_,_,_,X,_], [_,_,_,X,_]],X) :- X \= v.

colunas([[_,_,_,_,X],[_,_,_,_,X],[_,_,_,_,X], [_,_,_,_,_]],X) :- X \= v.
colunas([[_,_,_,_,_],[_,_,_,_,X],[_,_,_,_,X], [_,_,_,_,X]],X) :- X \= v.


diagonal([[X,_,_,_,_],[_,X,_,_,_],[_,_,X,_,_], [_,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[_,X,_,_,_],[_,_,X,_,_], [_,_,_,X,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[X,_,_,_,_],[_,X,_,_,_], [_,_,X,_,_]],X) :- X \= v.
diagonal([[_,X,_,_,_],[_,_,X,_,_],[_,_,_,X,_], [_,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[_,_,X,_,_],[_,_,_,X,_], [_,_,_,_,X]],X) :- X \= v.
diagonal([[_,_,X,_,_],[_,_,_,X,_],[_,_,_,_,X], [_,_,_,_,_]],X) :- X \= v.

diagonal([[_,_,X,_,_],[_,X,_,_,_],[X,_,_,_,_], [_,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[_,_,X,_,_],[_,X,_,_,_], [X,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,X,_],[_,_,X,_,_],[_,X,_,_,_], [_,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,X],[_,_,_,X,_],[_,_,X,_,_], [_,_,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[_,_,_,X,_],[_,_,X,_,_], [_,X,_,_,_]],X) :- X \= v.
diagonal([[_,_,_,_,_],[_,_,_,_,X],[_,_,_,X,_], [_,_,X,_,_]],X) :- X \= v.

cheio([L1,L2,L3,L4]) :-
    append(L1,L2, L12),
    append(L12, L3, L123),
    append(L123, L4, L1234)
    \+ member(v, L1234).

%função de utilidade, retorna o valor dos estados terminais, 1 ganha -1 perde
valor(G, 1) :- linhas(G,x).
valor(G, 1) :- colunas(G,x).
valor(G, 1) :- diagonal(G,x).
valor(G, -1) :- linhas(G,o).
valor(G, -1) :- colunas(G,o).
valor(G, -1) :- diagonal(G,o).
valor(_, 0).

% oper(estado,jogador,jogada,estado seguinte)
oper(E, J,joga(X,Y), En) :-
	joga_vazio(E,J,X, Y, En).

joga_vazio([[v,C2,C3],L2,L3], J, 1, 1, [[J,C2,C3],L2,L3]).
joga_vazio([[C1,v,C3],L2,L3], J, 1, 2, [[C1,J,C3],L2,L3]).
joga_vazio([[C1,C2,v],L2,L3], J, 1, 3, [[C1,C2,J],L2,L3]).
joga_vazio([L1,[v,C2,C3],L3], J, 2, 1, [L1,[J,C2,C3],L3]).
joga_vazio([L1,[C1,v,C3],L3], J, 2, 2, [L1,[C1,J,C3],L3]).
joga_vazio([L1,[C1,C2,v],L3], J, 2, 3, [L1,[C1,C2,J],L3]).
joga_vazio([L1,L2,[v,C2,C3]], J, 3, 1, [L1,L2,[J,C2,C3]]).
joga_vazio([L1,L2,[C1,v,C3]], J, 3, 2, [L1,L2,[C1,J,C3]]).
joga_vazio([L1,L2,[C1,C2,v]], J, 3, 3, [L1,L2,[C1,C2,J]]).

