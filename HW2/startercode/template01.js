var helpers = require( './helpers' );
var pt = require( './csce322h0mework02part01' );

var maze = helpers.readMazeFile('part01test01.maze.m');
var moves = helpers.readMovesFile('part01test01.moves.m');
var before = maze.slice(0);
var theFunction = pt.onePlayerOneMove( before );
var after = theFunction( moves[0] );

helpers.printMaze( after );
