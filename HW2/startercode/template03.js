var helpers = require( './helpers' );
var pt = require( './csce322h0mework02part03' );

var maze = helpers.readMazeFile('part03test01.maze.m');
var moves = helpers.readMovesFile('part03test01.moves.m');
var before = maze.slice(0);

var theFunction = pt.manyPlayersOneMove( before );
var after = theFunction( moves );
helpers.printMaze( after );
