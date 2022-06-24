movesAndPlayers(Moves,Maze):-
    lengthMoves(Moves,LenMoves),
    convertMazeAndCount(Maze,NumbOfPlayers),
    isEven(LenMoves,X),
    isEven(NumbOfPlayers,Y),
    check(X,Y),
    !.


%all possible players
player(1).
player(2).
player(3).
player(4).

%all possible moves
move(r).
move(u).
move(l).
move(d).
	
isEven(X,Res) :-
    0 is mod(X,2),
    Res is 1.
isEven(X,Res) :-
    1 is mod(X,2),
    Res is 0.
           
flatten([], []) :- !.
flatten([H|T], FlatL) :-
    !,
    flatten(H, Rec1),
    flatten(T, Rec2),
    append(Rec1, Rec2, FlatL).
flatten(L, [L]).

lengthMoves([],0) :- !.
lengthMoves([_|T],L) :-
	lengthMoves(T,L1), 
	L is L1+1,
    	!.

convertMazeAndCount(Maze,Count):-
  	flatten(Maze,FMaze),
  	countPlayers(FMaze,Count).

countPlayers([],0):- !.
countPlayers([H|T],Count):-
  	not(player(H)),
  	countPlayers(T,Count),
    	!.

countPlayers([_|T],Count):-
  	countPlayers(T,Count2),
  	Count is Count2 + 1.

check(A,B) :-
	A =:= B.

	