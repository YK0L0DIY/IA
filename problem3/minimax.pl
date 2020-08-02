joga :- estado_inicial(Ei), joga(Ei).

pede_coluna(Coluna):-
    read(Coluna).

joga_pc(Ei):-terminal(Ei),write("Game Over!!!!").
joga_pc(Ei):-minimax_decidir(Ei, joga(X,Y)),
             write(joga(X,Y)),nl,
             joga_vazio(Ei, x, X, Y, Enn),
             joga(Enn).

joga(Ei):- terminal(Ei),printTable(Ei),write("Game Over!!!!").
joga(Ei) :-printTable(Ei),
            pede_coluna(Coluna),
            joga_vazio(Ei, o, _, Coluna, En),
            printTable(En),
            joga_pc(En).

printTable([]).
printTable([T|Tl]):-
    write(T),nl,
    printTable(Tl).

% decide qual é a melhor jogada num estado do jogo
% minimax_decidir(Estado, MelhorJogada)

% se é estado terminal não há jogada 
minimax_decidir(Ei,terminou) :- terminal(Ei).

% Para cada estado sucessor de Ei calcula o valor minimax do estado
% Opf é o operador (jogada) que tem maior valor
% Nota: assume que o jogador é o "x"
minimax_decidir(Ei,Opf) :- 
	findall(Vc-Op, (oper(Ei,x,Op,Es), minimax_valor(Es,Vc,1)), L),
	escolhe_max(L,Opf).

% se um estado é terminal o valor é dado pela função de utilidade
% Nota: assume que o jogador é o "x"
minimax_valor(Ei,Val,_) :- 
	terminal(Ei), 
	valor(Ei,Val).

%Se o estado não é terminal o valor é:
% -se a profundidade é par, o maior valor dos sucessores de Ei
% -se aprofundidade é impar o menor valor dos sucessores de Ei
minimax_valor(Ei,Val,P) :- 
	P1 is P+1, jogador(P1,J),
	findall(Val1, (oper(Ei,J,_,Es), minimax_valor(Es,Val1,P1)), V),
	seleciona_valor(V,P,Val).


% jogador "x" nas jogadas impares e jogador "o" nas jogadas pares
jogador(P, o) :- X is P mod 2, X = 0.
jogador(P, x) :- X is P mod 2, X = 1.

% Se a profundidade (P) é par, retorna em Val o maximo de V
seleciona_valor(V,P,Val) :- 
	X is P mod 2, X=0,!, 
	maximo(V,Val).

% Senão retorna em Val o minimo de V
seleciona_valor(V,_,Val):- minimo(V,Val).

%% Predicados auxiliares

escolhe_max([A|R],Val):- escolhe_max(R,A,Val).

escolhe_max([],_-Op,Op).
escolhe_max([A-_|R],X-Op,Val) :- A < X,!, escolhe_max(R,X-Op,Val).
escolhe_max([A|R],_,Val):- escolhe_max(R,A,Val).


maximo([A|R],Val):- maximo(R,A,Val).

maximo([],A,A).
maximo([A|R],X,Val):- A < X,!, maximo(R,X,Val).
maximo([A|R],_,Val):- maximo(R,A,Val).

minimo([A|R],Val):- minimo(R,A,Val).

minimo([],A,A).
minimo([A|R],X,Val):- A > X,!, minimo(R,X,Val).
minimo([A|R],_,Val):- minimo(R,A,Val).

