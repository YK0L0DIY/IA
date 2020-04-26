joga :- estado_inicial(Ei), joga(Ei).

joga(Ei) :- pede_coluna(Coluna),
            joga_vazio(Ei, o, Coluna, _, En),
            minimax_decidir(En, ISTO),
            joga_vazio(En, x, ISTOX, ISTOY, Enn),
            joga(Enn).

joga_vazio([[v, C12, C13, C14, C15],
            [C21, C22, C23, C24, C25],
            [C31, C32, C33, C34, C35],
            [C41, C42, C43, C44, C45]],
            J,
            1,1,
            [[J, C12, C13, C14, C15],
            [C21, C22, C23, C24, C25],
            [C31, C32, C33, C34, C35],
            [C41, C42, C43, C44, C45]]):- C21 \= v, C31 \= v, C41 \= v.

cheio([L1,L2,L3,L4]) :-
    append(L1,L2, L12),
    append(L12, L3, L123),
    append(L123, L4, L1234)
    \+ member(v, L1234).
