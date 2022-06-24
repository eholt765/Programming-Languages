module.exports = {
    readMazeFile:readMazeFile,
    readMovesFile:readMovesFile,
    printMaze:printMaze,
    printMoves:printMoves
}

function readMazeFile( file )
{
    var text;
    var lines = [];
    var rows = [];
    var filesystem = require( 'fs' );

    text = filesystem.readFileSync( file );
    rows = text.toString().split( "\n" );
    rows.pop();
    
    var maze = [];
    for( var r = 0; r < rows.length; r++ ){
	maze[r] = rows[r].toString().split( "," );
    }
    
    return maze;
}

function readMovesFile( file )
{
    var text;
    var line = [];
    var filesystem = require( 'fs' );
    var row = [];
    var mvs = [];
    var moves = [];

    text = filesystem.readFileSync( file );
    mvs = text.toString().split( "\n" );
    moves = mvs[0].toString().split( "," );
    return moves; 
}

function printMaze(maze){
    for( var r = 0; r < maze.length; r++ ){
	var row = "";
	for( var c = 0; c < maze[r].length; c++ ){
	    row = row + maze[r][c];
	}
	console.log( row );
    }
}

function printMoves(moves){
    var moveString = "";
    for( var m = 0; m < moves.length; m++ ){
	moveString = moveString + moves[m];
    }
    console.log( moveString );
}

