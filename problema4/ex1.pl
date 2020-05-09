:- dynamic(tamanho/1).
:- dynamic(estado_inicial/1).

%estado inicial consoante o tamanho
criar_estado_inicial():-
    tamanho(T),
    length(N, T),
    T1 is T +1,
    maplist(random(1,T1), N),
    asserta(estado_inicial(N)).

mover([_|[]],1,Y,[Y]).
mover([_|T],1,Y,[Y|T]).

mover([E|T],X,Y,[E|En]):-
    X \= 1,
    X1 is X-1,
    mover(T,X1,Y,En).

% realizar joagada
% op(estadio_inicial, nome_jogada, rainha_a_mover, posicao_para_onde_mocer, estado_resultante)
op(E,mover,X,Y,En) :-
    tamanho(N),
    X > 0,
    N >= X,
    Y > 0,
    N >= Y,
    mover(E,X,Y,En).

% verificar se e estado final
estado_final(E) :-
    tamanho(N),
    queens(N,E).

% algoritmo pesquisa
pesquisa_local_hill_climbingSemCiclos(E, _) :-
	estado_final(E),
	write(E), write(' ').

pesquisa_local_hill_climbingSemCiclos(E, L) :-
	write(E), write(' '),
	expande(E,LSeg),
	sort(3, @=<, LSeg, LOrd),
	obtem_no(LOrd, no(ES, Op, _)),
	\+ member(ES, L),
	write(Op), nl,
	(pesquisa_local_hill_climbingSemCiclos(ES,[E|L]) ; write(undo(Op)), write(' '), fail).

expande(E, L):-
	findall(no(En,Opn, Heur),
                (op(E,Opn,En,_), heur(En, Heur)),
                L).

obtem_no([H|_], H).
obtem_no([_|T], H1) :-
	obtem_no(T, H1).

pesquisa(N,R) :-
    asserta(tamanho(N)),
	criar_estado_inicial(),
	estado_inicial(E),!,
	write(E),nl,
	safe(E,R).
	%pesquisa_local_hill_climbingSemCiclos(S0, []).

heu([],0).
heu([Queen|Others],R) :-
    heu(Others,R0),
    sum_d1(Queen,Others,1,R1),
    sum_d2(Queen,Others,1,R2),
    sum_L(Queen,Others,R3),
    R is R0+R1 +R2+R3.

sum_d1(_,[],_,0).
sum_d1(Y,[Y1|Ylist],Xdist,S):-
    Y2 is Y1-Y,
    Y2 \= Xdist,
    Dist1 is Xdist + 1,
    sum_d1(Y,Ylist,Dist1,S).

sum_d1(Y,[Y1|Ylist],Xdist,S):-
    Y2 is Y1-Y,
    Y2 is Xdist,
    Dist1 is Xdist + 1,
    sum_d1(Y,Ylist,Dist1,S1),
    S is S1 +1.

sum_d2(_,[],_,0).
sum_d2(Y,[Y1|Ylist],Xdist,S):-
    Y2 is Y-Y1,
    Y2 \= Xdist,
    Dist1 is Xdist + 1,
    sum_d2(Y,Ylist,Dist1,S).

sum_d2(Y,[Y1|Ylist],Xdist,S):-
    Y2 is Y-Y1,
    Y2 is Xdist,
    Dist1 is Xdist + 1,
    sum_d2(Y,Ylist,Dist1,S1),
    S is S1 +1.

sum_L(_,[],0).
sum_L(Y,[Y1|Ylist],S):-
    Y \= Y1,
    sum_L(Y,Ylist,S).

sum_L(Y,[Y1|Ylist],S):-
    Y is Y1,
    sum_L(Y,Ylist,S1),
    S is S1 +1.

criar_tabuleiro([], []).
criar_tabuleiro([H|T], [Lista1|TL]) :-
    tamanho(N),
    N1 is N-1,
    create_list_of_Zeros(N1,Lista),
    nth1(H, Lista1, 1,Lista),
    criar_tabuleiro(T,TL).

create_list_of_Zeros(1,[0]).
create_list_of_Zeros(X,[0|T]) :-
    X1 is X -1,
    create_list_of_Zeros(X1,T).
