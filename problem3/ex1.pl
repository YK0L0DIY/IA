%
% matrix devolve as Rows Cols da matrix
%

matrix(NRows, NCols, Rows, Cols) :-
    create_mat(NRows, NCols, Rows),
    extract_columns(NCols, Rows, Cols).

fill([], _).
fill([X|Xs], X) :- fill(Xs, X).

create_mat(0, _, []).
create_mat(N0, N, [Line|Matrix]) :-
    N0 > 0,
    N1 is N0 - 1,
    length(Line, N),
    fill(Line,'v'),
    create_mat(N1, N, Matrix).

extract_columns(NCols, Rows, Cols) :-
    NCols1 is NCols + 1,
    extract_columns(NCols, NCols1, Rows, Cols).
    extract_columns(0, _, _, []) :- !.

extract_columns(N, Max, Rows, [Col|Cols]) :-
    InvN is Max - N,
    extract(Rows,Col, InvN),
    N1 is N - 1,
    extract_columns(N1, Max, Rows, Cols).

extract(Rows, Col, N) :-
    maplist(nth1(N), Rows, Col).