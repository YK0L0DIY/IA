create_mat(0, _, []).
create_mat(N0, N, [Line|Matrix]) :-
	N0 > 0,
	N1 is N0 - 1,
	length(Line, N),
	create_mat(N1, N, Matrix).

sum_row([], _).
sum_row([Row|Matrix], SumDim) :-
	sum(Row, SumDim),
	sum_row(Matrix, SumDim).

sum([],0).
sum(L,Sum):-sum(L,0,Sum).
sum([],X,Y):-X #= Y.
sum([E|L],S,Sum):-
    S1 #= S+E,
    sum(L,S1,Sum).

diagonal_sum(Matrix, I, P, Result):-
    diagl(Matrix, I, P, List),
    sum(List,Result).

diagl([], _,_, []).
diagl([Row|Matrix], Idx, P, [X|LDiag]) :-
	nth1(Idx, Row, X),
	Idx1 is Idx+P,
	diagl(Matrix, Idx1, P, LDiag).

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

magic_square(N, Vars) :-
	Nmax is N * N,
	create_mat(N, N, Matrix),
	flatten(Matrix, Vars), % cria-se a linha completa
	fd_domain(Vars,1,Nmax), % limita-se as variavies
	fd_all_different(Vars), % todos teem de ser diferentes
    sum_row(Matrix, SumDim), % veririfca-se se a soma das linhas é correta
    trans(Matrix,TMatrix), % faz-se a transposta
    sum_row(TMatrix,SumDim), % calcula-se a soma das linhas da transposta
    diagonal_sum(Matrix,N,-1,SumDim), % calcula-se a diagonal crescente
    diagonal_sum(Matrix,1,+1,SumDim), % calcula-se a diagonal decrescente
    fd_labeling(Vars). %  fim