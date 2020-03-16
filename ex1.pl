%Descricao do problema:

%estado_inicial(Estado)
estado_inicial([1,1]).

%estado_final(Estado)
estado_final([4,4]).

%restricoes

%tamanho_tabela
tamanhoX(4).
tamanhoY(4).

%representacao dos operadores
%op(Eact,OP,Eseg,Custo)

op([X,Y], cima, [X,Y1], 1) :-
    Y > 1,
    Y1 is Y - 1.

op([X,Y], baixo, [X,Y1], 1) :-
    tamanhoY(T),
    Y < T,
    Y1 is Y + 1.

op([X,Y], esquerda, [X1,Y], 1) :-
    X > 1,
    X1 is X - 1.

op([X,Y], direita, [X1,Y], 1) :-
    tamanhoX(T),
    X < T,
    X1 is X + 1.

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
