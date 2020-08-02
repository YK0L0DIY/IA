:- dynamic(tamanho/1).
:- dynamic(estado_inicial/1).
:- use_module(library(clpfd)).

%estado inicial consoante o tamanho
criar_estado_inicial():-
    tamanho(T),
    length(N, T),
    T1 is T +1,
    maplist(random(1,T1), N),
    asserta(estado_inicial(N)).

% Dado um estado E move a rainha X para a posição Y, formando En.
mover([_|[]],1,Y,[Y]).
mover([_|T],1,Y,[Y|T]).

mover([E|T],X,Y,[E|En]):-
    X1 is X-1,
    mover(T,X1,Y,En).

% realizar joagada
% op(estadio_inicial, [rainha_a_mover, posicao_para_onde_mover], estado_resultante, peso_da_op)
op(E,[X,Y],En,1) :-
    tamanho(N),!,
    [X,Y] ins 1..N, labeling([max(X),min(Y)],[X,Y]), %gera valores de X e y entre 1 e o tamanho. Nao meche no taboleiro
    mover(E,X,Y,En).

% verificar se e estado final
estado_final(E) :-
    tamanho(N),
    queens(N,E).

print_elements([]).             % print de um elemento
print_elements([Element|T]):-
    write(Element),print_elements(T).

print_rows([]).               % print da matrix
print_rows([H|T]) :- print_elements(H), nl, print_rows(T).

% retirado da net http://blog.ivank.net/prolog-matrices.html
% trans(+M1, -M2) - transpose of square matrix
% 1. I get first column from Tail and make a first row (NT) from it
% 2. I transpose "smaller matrix" Rest into NRest
% 3. I take T and make it to be a first column of NTail

trans([[H|T] |Tail], [[H|NT] |NTail]) :-
    firstCol(Tail, NT, Rest), trans(Rest, NRest), firstCol(NTail, T, NRest).
trans([], []).

% firstCol(+Matrix, -Column, -Rest)  or  (-Matrix, +Column, +Rest)

firstCol([[H|T] |Tail], [H|Col], [T|Rows]) :- firstCol(Tail, Col, Rows).
firstCol([], [], []).

%cira tabuleiro para display
criar_tabuleiro([], []).
criar_tabuleiro([H|T], [Lista1|TL]) :-
    tamanho(N),
    N1 is N-1,
    create_list_of_Zeros(N1,Lista),
    nth1(H, Lista1, ' Q ',Lista),
    criar_tabuleiro(T,TL).

create_list_of_Zeros(1,[' _ ']).
create_list_of_Zeros(X,[' _ '|T]) :-
    X1 is X -1,
    create_list_of_Zeros(X1,T).

time(A) :-
       statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
       pesquisa(A),
       statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
       write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

% algoritmo pesquisa
pesquisa_local_hill_climbingSemCiclos(E, _) :-
	estado_final(E),
	write(E), write(' '), nl, nl,
    criar_tabuleiro(E, T),
    trans(T, T1),
    print_rows(T1).

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

% cria um tabuleiro com tamnho N.
% cria um estado inicial para mesmo.
% efetua movimentos de modo a que as rainhas no estado inicial deixem de se atacar.
pesquisa(N) :-
    asserta(tamanho(N)),
	criar_estado_inicial(),
	estado_inicial(E),!,
	pesquisa_local_hill_climbingSemCiclos(E, []).

% Dado um estado devolve o númeor de ataques nesse estado.
heur([],0).
heur([Queen|Others],R) :-
    heur(Others,R0),
    sum_d1(Queen,Others,1,R1),
    sum_d2(Queen,Others,1,R2),
    sum_L(Queen,Others,R3),
    R is R0+R1 +R2+R3.

% Diagonal Y=-X. Verifica se há ataques na mesma e devolve a sua soma.
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

% Diagonal Y=X. Verifica se há ataques na mesma e devolve a sua soma.
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

% Linha. Verifica se há ataques na mesma e devolve a sua soma.
sum_L(_,[],0).
sum_L(Y,[Y1|Ylist],S):-
    Y \= Y1,
    sum_L(Y,Ylist,S).

sum_L(Y,[Y1|Ylist],S):-
    Y is Y1,
    sum_L(Y,Ylist,S1),
    S is S1 +1.