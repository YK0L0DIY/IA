
:- use_module(library(clpfd)).

ok([]).
ok([R|Rs]) :- ok(Rs, R, 1), ok(Rs).

ok([], _, _).
ok([Rj|Rs], Ri, I) :-
    I1 is I+1,
    ok(Rs, Ri, I1),
    Ri #\= Rj, Ri #\= Rj+I, Ri+I #\= Rj.

queens(N, R) :-
    length(R, N),
    R ins 1..N,
    ok(R).