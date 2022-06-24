var helpers = require( './helpers' );
var pt = require( './csce322h0mework02part02' );

var maze = helpers.readMazeFile('part02test01.maze.m');
var moves = helpers.readMovesFile('part02test01.moves.m');
var before = maze.slice(0);

var theFunction = pt.onePlayerManyMoves( before );
var after = theFunction( moves );
helpers.printMaze( after );
