notVertical(Maze):-
    not(getTopAndBottom(Maze)).

getLen([],0) :- !.
getLen([_|T],L) :- 
    !,
    getLen(T,L1), 
    L is L1+1.

getCols([], 0) :- !.
getCols([H|_],Cols) :-
    !,
    getLen(H,Cols).

getRows([],0) :- !.
getRows(Maze,Rows) :-
    !,
    getCols(Maze,C),
    flatten(Maze, FMaze),
    getLen(FMaze, L),
    Rows is L/C.

flatten([], []) :- !.
flatten([H|T], FlatL) :-
    !,
    flatten(H, Rec1),
    flatten(T, Rec2),
    append(Rec1, Rec2, FlatL).
flatten(L, [L]).

elemAtI([E|_],0,E) :- !.
elemAtI([_|T],I,E) :-
    I > 0,
    I1 is I-1,
    elemAtI(T,I1,E).

% member(Item,List)
member(Item,[Item|_]):-!.
member(Item,[_|T]):-
    member(Item,T).

getTopAndBottom(Maze):-
	getRows(Maze, R),
	elemAtI(Maze, 0, X),
	elemAtI(Maze, (R-1), Y),
	append(Y, X, NewList),
    flatten(NewList, FinalList),
    member(-,FinalList),
	!.
	
	