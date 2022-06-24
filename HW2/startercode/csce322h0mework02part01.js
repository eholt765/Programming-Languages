module.exports = {
  onePlayerOneMove: onePlayerOneMove
}

var helpers = require('./helpers');

function onePlayerOneMove(maze) {

  function whatever(move) {
    maze = updatedMaze('1', move, maze);
    return maze;
  }

  return whatever;
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

function withinRange(x, y, maze){
  var rowLen = maze.length;
  var colLen = maze[0].length;
  var safe = 0;
  if ((x >= 0) && (x <= rowLen) && (y >= 0) && (y <= colLen)){
    safe = 1;
  }
  return safe;
}

function markUpMaze(x, y, player, maze) {
  maze[x][y] = "-";
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
  else if ((maze[r][c-1]) == "x"){
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
  else if ((maze[r][c+1]) == "x"){
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
  else if ((maze[r+1][c]) == "x"){
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
  else if ((maze[r-1][c]) == "x"){
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
  unmarkMaze(player, maze);
  return maze;
}