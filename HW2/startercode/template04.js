var helpers = require( './helpers' );
var pt = require( './csce322h0mework02part04' );

var maze = helpers.readMazeFile('part04test01.maze.m');
var moves = helpers.readMovesFile('part04test01.moves.m');
var before = maze.slice(0);

var theFunction = pt.manyPlayersManyMoves( before );
var after = theFunction( moves );
helpers.printMaze( after );
