:- module( helpers,
	   [ readMazeFile/3
	    ,printMazeGame/1
	   ]
	 ).

prefix([_],[]).
prefix([H|T],[H|P]):-
    prefix(T,P).

readMazeFile(File,Moves,Maze):-
    open(File,read,Input),
    read(Input,Moves),
    readMaze(Input,Temp),
    prefix(Temp,Maze),
    close(Input).

readMaze(Input,[]):-
    at_end_of_stream(Input),
    !.
readMaze(Input,[Row|Rows]):-
    \+ at_end_of_stream(Input),
    read(Input,Row),
    readMaze(Input,Rows).

printMazeGame([]).
printMazeGame([Row|Rows]):-
    writeln(Row),
    printMazeGame(Rows).
