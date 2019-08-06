
%predicate number 1
grid_build(N,M):-
	grid_build(1,N,M).
grid_build(Start,N,_):- Start>N.
grid_build(Start,N,[H|T]):-
	Start=<N,
	length(H,N),
	S2 is Start+1,
	grid_build(S2,N,T).

num_gen(L,L,[L]).
num_gen(F,L,[F|T]):-
	F<L,
	F2 is F+1,
	num_gen(F2,L,T).
	
%to get maximum value in  a grid	
getMax([],0).
getMax(X,X):- X\=[_|_],X\=[].
getMax([H|T],R):-
	getMax(H,R1),
	getMax(T,R2),
	R1>=R2,
	R=R1.
getMax([H|T],R):-
	getMax(H,R1),
	getMax(T,R2),
	R2>=R1,
	R=R2.
	

%to flatten a grid 

flatten([],[]).
flatten([H|T],R):-
	flatten(T,R2),
	append(H,R2,R).
	
check_num_grid(G):-
	getMax(G,M),
	num_gen(1,M,L),
	length(G,N),
	M=<N,
	flatten(G,R),
	sublist(L,R),!.

	
member1(X,[X|_]).
member1(X,[H|T]):-
	X\=H,
	member1(X,T).
sublist([],_).	
sublist([H|T],R):-
	member(H,R),
	sublist(T,R).
	
acceptable_permutation(L,R):-
	permutation(L,R),
	acceptable_permutation_helper(L,R).
	
acceptable_permutation_helper([],[]).
acceptable_permutation_helper([H1|T1],[H2|T2]):-
	H1\=H2,
	acceptable_permutation_helper(T1,T2).
	

grid_gen(N,M):-
	length(M,N),
	num_gen(1,N,L),
	grid_gen(1,N,L,M).
	
grid_gen(Start,N,_,_):- Start>N.
grid_gen(Start,N,L,[H|T]):-
	Start=<N,
	S2 is Start +1,
	length(H,N),
	sublist(H,L),
	grid_gen(S2,N,L,T).
	
% to get element at indexx N in List L 
	
getElement(N,L,R):-getElement(1,N,L,R).
getElement(N,N,[R|_],R).
getElement(Acc,N,[_|T],R):-
	Acc<N,
	Acc2 is Acc+1,
	getElement(Acc2,N,T,R).

% to get NTH element from eachh list in a grid 
	
getElementFromGrid(_,[],[]).
getElementFromGrid(N,[H|T],[R1|R2]):-
	getElement(N,H,R1),
	getElementFromGrid(N,T,R2).
	
	
% to get transpose of a grid 
	
trans(G,R):-
	length(G,N),
	trans(1,N,G,R).
trans(Start,N,_,[]):-Start>N.
trans(Start,N,G,[R1|R2]):-
	Start=<N,
	getElementFromGrid(Start,G,R1),
	S2 is Start+1,
	trans(S2,N,G,R2).
	
% to make sure that there isn't an identical row andd column in the same indexx	
	
acceptable_distribution(G):-
	trans(G,R),
	acceptable_distribution_helper(G,R).
	
acceptable_distribution_helper([],[]).	
acceptable_distribution_helper([H1|T1],[H2|T2]):-
	H1\=H2,
	acceptable_distribution_helper(T1,T2).
	
% to get Index of a row in a grid 
	
getRowIndex(L,[L|_],1).
getRowIndex(L,[H|T],N):-
	L\=H,
	getRowIndex(L,T,N1),
	N is N1 +1.

% to check weather a row existss in  a grid	
findRow(L,[L|_]).
findRow(L,[H|T]):-
	L\=H,
	findRow(L,T).

row_col_match(M):-
	trans(M,MT),
	row_col_match(1,M,MT).
row_col_match(_,[],_).
row_col_match(Index,[H|T],MT):-
	findRow(H,MT),
	getRowIndex(H,MT,I2),
	Index\=I2,
	Index2 is Index +1,
	row_col_match(Index2,T,MT).
% to count the number of timess a row occurs in a grid 
countTimes(_,[],0).
countTimes(L,[H|T],N):-
	L=H,
	countTimes(L,T,N2),
	N is N2 +1.
countTimes(L,[H|T],N):-
	L\=H,
	countTimes(L,T,N).

distinct_rows(G):-
	distinct_rows(G,G).
distinct_rows([],_).
distinct_rows([H|T],G):-
	countTimes(H,G,1),
	distinct_rows(T,G).
distinct_columns(M):-
	trans(M,MT),
	distinct_rows(MT).
	
helsinki(N,G):-
	grid_gen(N,G),
	row_col_match(G),
	distinct_columns(G),
	distinct_rows(G),
	check_num_grid(G).
	
	