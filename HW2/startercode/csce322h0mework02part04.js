module.exports = {
    manyPlayersManyMoves: manyPlayersManyMoves
}

var helpers = require( './helpers' );

function manyPlayersManyMoves( maze ){
        
    function whatever( moves ){
      var number_of_players = playerCount(maze);
      var players = [];
      for(var j = 1; j < (number_of_players+1); j++){
        players[j-1] = j;
      }
      nextplayer = 0;
      for(var i = 0; i < (moves.length); i++){
			  maze = updatedMaze(players[nextplayer], moves[i], maze);
        var solved = mazeSolved(maze);
        if (solved == 1){
          i = ((moves.length) + 1);
        }
        unmarkMaze(players[nextplayer], maze);
        nextplayer++;
        if (nextplayer == number_of_players){
          nextplayer = 0;
        }
      }
		
	    return maze;
    }

    return whatever;
}

function mazeSolved(maze) {
  for (var i = 0; i < maze.length; i++) {
    for (var j = 0; j < maze[i].length; j++) {
      if (maze[i][j] == "O"){
        return 0;
      } 
    }
  }
  return 1;
}

function playerLocation(player, maze) {
  for (var i = 0; i < maze.length; i++) {
    for (var j = 0; j < maze[i].length; j++) {
      if (maze[i][j] == player) {
        return [i, j];
      }
    }
  }
  return -1;
}

function playerCount(maze) {
  var count = 0;
  for (var i = 0; i < maze.length; i++) {
    for (var j = 0; j < maze[i].length; j++) {
      if ((maze[i][j] == 1) || (maze[i][j] == 2) || (maze[i][j] == 3) || (maze[i][j] == 4)) {
        count++;
      }
    }
  }
  return count;
}

function markUpMaze(x, y, player, maze) {
  maze[x][y] = "-";
  var player1Present = 0;
  var xp1 = -1;
  var yp1 = -1;
  var player2Present = 0;
  var xp2 = -1;
  var yp2 = -1;
  var player3Present = 0;
  var xp3 = -1;
  var yp3 = -1;
  var player4Present = 0;
  var xp4 = -1;
  var yp4 = -1

  for (var a = 0; a < maze.length; a++) {
    for (var b = 0; b < maze[a].length; b++) {
      if (maze[a][b] == 1){
        player1Present = 1;
        xp1 = a;
        yp1 = b;
        maze[a][b] = 'x';
      }
      else if (maze[a][b] == 2){
        player2Present = 1;
        xp2 = a;
        yp2 = b;
        maze[a][b] = 'x';
      }
      else if (maze[a][b] == 3){
        player3Present = 1;
        xp3 = a;
        yp3 = b;
        maze[a][b] = 'x';
      }
      else if (maze[a][b] == 4){
        player4Present = 1;
        xp4 = a;
        yp4 = b;
        maze[a][b] = 'x';
      }
    }
  }
  for (var i = 0; i < maze.length; i++) {
    for (var j = 0; j < maze[i].length; j++) {
      if(maze[i][j] == "-"){
        var avail_u = 0;
        var avail_d = 0;
        var avail_l = 0;
        var avail_r = 0;
        var sym_l = "";
        var sym_r = "";
        var sym_u = "";
        var sym_d = "";

        var b1 = ((maze.length)-1); 
        var b2 = 0;
        var b3 = 0;
        var b4 = ((maze[i].length)-1);
        if ((i == b1) || (i == b2) || (j == b3) || (j == b4)){
          maze[i][j] = "O";
        }

        if ((i-1) >= 0){
          sym_u = maze[i-1][j];
        }
        if ((i+1) < maze.length){
          sym_d = maze[i+1][j];
        }
        if ((j-1) >= 0){
          sym_l = maze[i][j-1];
        }
        if ((j+1) < maze[i].length){
          sym_r = maze[i][j+1]
        }
        if ((sym_u != "x")){
          avail_u = 1;
        }
        if ((sym_d != "x")){
          avail_d = 1;
        }
        if ((sym_l != "x")){
          avail_l = 1;
        }
        if ((sym_r != "x")){
          avail_r = 1;
        }
        if ((avail_u + avail_d + avail_l + avail_r) >= 3){
          maze[i][j] = "D";
        }
        else if((avail_u == 1) && (avail_r == 1) && (avail_d == 0) && (avail_l == 0) ){
          maze[i][j] = "S"
        }
        else if((avail_u == 1) && (avail_r == 0) && (avail_d == 0) && (avail_l == 1) ){
          maze[i][j] = "T"
        }
        else if((avail_u == 0) && (avail_r == 1) && (avail_d == 1) && (avail_l == 0) ){
          maze[i][j] = "Q"
        }
        else if((avail_u == 0) && (avail_r == 0) && (avail_d == 1) && (avail_l == 1) ){
          maze[i][j] = "R"
        }
      }
    }
  }
  if (player1Present == 1){
    maze[xp1][yp1] = 1;
  }
  if (player2Present == 1){
    maze[xp2][yp2] = 2;
  }
  if (player3Present == 1){
    maze[xp3][yp3] = 3;
  }
  if (player4Present == 1){
    maze[xp4][yp4] = 4;
  }
  maze[x][y] = player;
  return maze;
}

function move_L(r, c, player, maze){
  var oldR = r;
  var oldC = c;
  while ((maze[r][c-1]) == "-"){
    c--;
  }
  if ((maze[r][c-1]) == "O"){
    c--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else if ((maze[r][c-1]) == "Q"){
    c--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_D(r, c, player, maze);
  }
  else if ((maze[r][c-1]) == "S"){
    c--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_U(r, c, player, maze);
  }
  else if (((maze[r][c-1]) == "x") || ((maze[r][c-1]) == "1") || ((maze[r][c-1]) == "2") || ((maze[r][c-1]) == "3") || ((maze[r][c-1]) == "4")) {
    if((r == oldR) && (c == oldC)){
      (maze[r][c]) = player;
    }
    else {
      (maze[r][c]) = player;
      (maze[oldR][oldC]) = "-";
    }
    return maze;
  }
  else if ((maze[r][c-1]) == "D"){
    c--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else {
    return maze;
  }
}

function move_R(r, c, player, maze){
  var oldR = r;
  var oldC = c;
  while ((maze[r][c+1]) == "-"){
    c++;
  }
  if ((maze[r][c+1]) == "O"){
    c++
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else if ((maze[r][c+1]) == "R"){
    c++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_D(r, c, player, maze);
  }
  else if ((maze[r][c+1]) == "T"){
    c++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_U(r, c, player, maze);
  }
  else if (((maze[r][c+1]) == "x") || ((maze[r][c+1]) == "1") || ((maze[r][c+1]) == "2") || ((maze[r][c+1]) == "3") || ((maze[r][c+1]) == "4")) {
    if((r == oldR) && (c == oldC)){
      (maze[r][c]) = player;
    }
    else {
      (maze[r][c]) = player;
      (maze[oldR][oldC]) = "-";
    }
    return maze;
  }
  else if ((maze[r][c+1]) == "D"){
    c++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else {
    return maze;
  }
}

function move_D(r, c, player, maze){
  var oldR = r;
  var oldC = c;
  while ((maze[r+1][c]) == "-"){
    r++;
  }
  if ((maze[r+1][c]) == "O"){
    r++
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else if ((maze[r+1][c]) == "T"){
    r++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_L(r, c, player, maze);
  }
  else if ((maze[r+1][c]) == "S"){
    r++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_R(r, c, player, maze);
  }
  else if (((maze[r+1][c]) == "x") || ((maze[r+1][c]) == "1") || ((maze[r+1][c]) == "2") || ((maze[r+1][c]) == "3") || ((maze[r+1][c]) == "4")) {
    if((r == oldR) && (c == oldC)){
      (maze[r][c]) = player;
    }
    else {
      (maze[r][c]) = player;
      (maze[oldR][oldC]) = "-";
    }
    return maze;
  }
  else if ((maze[r+1][c]) == "D"){
    r++;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else{
    return maze;
  }
}

function move_U(r, c, player, maze){
  var oldR = r;
  var oldC = c;
  while ((maze[r-1][c]) == "-"){
    r--;
  }
  if ((maze[r-1][c]) == "O"){
    r--
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else if ((maze[r-1][c]) == "R"){
    r--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_L(r, c, player, maze);
  }
  else if ((maze[r-1][c]) == "Q"){
    r--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-"
    move_R(r, c, player, maze);
  }
  else if (((maze[r-1][c]) == "x") || ((maze[r-1][c]) == "1") || ((maze[r-1][c]) == "2") || ((maze[r-1][c]) == "3") || ((maze[r-1][c]) == "4")) {
    if((r == oldR) && (c == oldC)){
      (maze[r][c]) = player;
    }
    else {
      (maze[r][c]) = player;
      (maze[oldR][oldC]) = "-";
    }
    return maze;
  }
  else if ((maze[r-1][c]) == "D"){
    r--;
    (maze[r][c]) = player;
    (maze[oldR][oldC]) = "-";
    return maze;
  }
  else{
    return maze;
  }
}

function unmarkMaze(player, maze){
  for (var i = 0; i < maze.length; i++) {
    for (var j = 0; j < maze[i].length; j++) {
      if (((maze[i][j]) == "D") || ((maze[i][j]) == "Q") || ((maze[i][j]) == "S") || ((maze[i][j]) == "T") || ((maze[i][j]) == "R") || ((maze[i][j]) == "O")){
        (maze[i][j]) = "-";
      }
    }
  }
  return maze;
}

function updatedMaze(player, move, maze){
  var currentLocation = playerLocation(player,maze);
  var row = currentLocation[0];
  var col = currentLocation[1];
  markUpMaze(row, col, player, maze);
  if (move == 'l'){
    move_L(row, col, player, maze);
  }
  if (move == 'r'){
    move_R(row, col, player, maze);
  }
  if (move == 'u'){
    move_U(row, col, player, maze);
  }
  if (move == 'd'){
    move_D(row, col, player, maze);
  }
  return maze;
}
