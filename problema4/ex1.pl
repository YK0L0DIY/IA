:- dynamic(tamanho/1).
:- dynamic(estado_inicial/1).

%estado inicial consoante o tamanho
criar_estado_inicial():-
    tamanho(T),
    length(N, T),
    maplist(random(1,T), N),
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

pesquisa(N) :-
    asserta(tamanho(N)),
	criar_estado_inicial().
	%pesquisa_local_hill_climbingSemCiclos(S0, []).