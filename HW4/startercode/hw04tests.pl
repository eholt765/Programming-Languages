printPaths([]).
printPaths([Path|Paths]):-
    writeln(Path),
    printPaths(Paths).

loadHelpers:-
    ['helpers'],
    ['csce322h0mework04part01'],
    ['csce322h0mework04part02'],
    ['csce322h0mework04part03'],
    ['csce322h0mework04part04'].
    
part01:-
    readMazeFile('part01test01.m',Moves,Maze),
    writeln(moves),
    writeln(Moves),
    writeln(maze),
    printMazeGame(Maze),
    movesAndPlayers(Moves,Maze).

part02:-
    readMazeFile('part02test01.m',_,Maze),
    writeln(maze),
    printMazeGame(Maze),
    setof(Moves,fewestDecisions(Maze,Moves),Paths),
    writeln(paths),
    printPaths(Paths).

part03:-
    readMazeFile('part03test01.m',_,Maze),
    writeln(maze),
    printMazeGame(Maze),
    notVertical(Maze).
    
part04:-
    readMazeFile('part04test01.m',_,Maze),
    writeln(maze),
    printMazeGame(Maze),
    decisionAdjacent(Maze).
    
