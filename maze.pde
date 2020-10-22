import java.util.Stack;
lavaMaze play = new lavaMaze(30);
float wid=30;
cell[][] gameGrid = play.getGrid();
boolean[][] vb;
boolean[][] drawn;
int[][] lava; // 0 = no lava, 1 = fresh lava, 2 = expired lava (cannot spread more)
float cellWidth = 600/wid;
cell pstart;
cell pend;
int pcol; //pointer column
int prow; //pointer row
int pstartcol;
int pstartrow;
int pendcol;
int pendrow;
int counter = 0;

void setup(){
  size(601,601);
  play.path(0,0);
  gameGrid=play.getGrid();
  drawn = new boolean[gameGrid.length][gameGrid.length];
  play.startEnd();
  pstart= play.getStart();
  pend=play.getEnd();
  pcol=pstart.cellCol();
  prow=pstart.cellRow();
  pstartcol=pstart.cellCol();
  pstartrow=pstart.cellRow();
  pendcol=pend.cellCol();
  pendrow=pend.cellRow();
  drawn[prow][pcol]=true;
  lava = new int[gameGrid.length][gameGrid.length];
  for(int i = 0; i<gameGrid.length; i++){
    for(int j = 0; j<gameGrid.length; j++){
      lava[i][j] = 0;
    }
  }
}

boolean movable=true;

void draw(){
  counter ++;
  for(int r=0; r<(int)(wid); r++){
    for(int c=0; c<(int)(wid); c++){
      cell a = gameGrid[r][c];
      if(drawn[r][c]==true){ // adds visited square
        fill(230);
        if(r == prow && c == pcol){
          fill(250);
        }
        noStroke();
        rect(c*cellWidth+1, r*cellWidth+1, cellWidth-1, cellWidth-1);
        stroke(230);
        if(r == prow && c == pcol){
          stroke(250);
        }
        drawOutlines(a, r, c, false);
      }
      
      else{ // adds other tiles
        fill(200);
        noStroke();
        rect(c*cellWidth+1, r*cellWidth+1, cellWidth-1, cellWidth-1);
        stroke(200);
        drawOutlines(a, r, c, false);
      }
    }
  }
  stroke(1);
  fill(0);
  for(int r=0; r<(int)(wid); r++){ // draws remaining outlines
    for(int c=0; c<(int)(wid); c++){
        cell a = gameGrid[r][c];
        if(lava[r][c] != 0){
          fill(230, 0, 0);
          stroke(230, 0, 0);
          rect(c*cellWidth+1, r*cellWidth+1, cellWidth-1, cellWidth-1);
        }
        stroke(1);
        fill(0);
        drawOutlines(a, r, c, true);
    }
  }
  if(pcol==pend.cellCol() && prow==pend.cellRow()){ // shows player 
      //they have reached the end
        noLoop();
        movable=false;
        textSize(70);
        fill(0);
        text("HOORAY!", 135, 265);
        textSize(60);
        text("YOU ESCAPED!", 85, 345);
  }
  if(lava[prow][pcol] != 0){
        noLoop();
        movable=false;
        textSize(50);
        fill(0);
        text("Uh oh!", 205, 265);
        textSize(47);
        text("It got toasty real quick...", 20, 325);
  }
  if(counter == 300){
    lava[pstartrow][pstartcol] = 1;
  }
  else if(counter > 300 && counter % 50 == 0){
    int[][] templava = new int[(int)(wid)][(int)(wid)];
    for(int i =0; i<(int)(wid); i++){
      for(int j = 0; j<(int)(wid); j++){
        templava[i][j] = lava[i][j];
      }
    }
    for(int i =0; i<(int)(wid); i++){
      for(int j = 0; j<(int)(wid); j++){
        if(lava[i][j] == 1){
          ArrayList<String> possible = getLavaDirections(i,j);
          if(possible.contains("up") && lava[i-1][j] !=2){
            templava[i-1][j] = 1;
          }
          if(possible.contains("down") && lava[i+1][j] !=2){
            templava[i+1][j] = 1;
          }
          if(possible.contains("left") && lava[i][j-1] !=2){
            templava[i][j-1] = 1;
          }
          if(possible.contains("right") && lava[i][j+1] !=2){
            templava[i][j+1] = 1;
          }
          templava[i][j] = 2;
          lava[i][j] = 2;
        }
      }
    }
    for(int i =0; i<(int)(wid); i++){
      for(int j = 0; j<(int)(wid); j++){
        lava[i][j] = templava[i][j];
      }
    }
  }
}

ArrayList<String> getLavaDirections(int row, int col){ // returns possible directions 
  //from player's current cell
    ArrayList<String> possible = new ArrayList<String>();
    if(col-1>=0 && gameGrid[row][col].getLeft()==false && lava[row][col-1] == 0){
      possible.add("left");
    }
    if(col+1< (int)(wid) && gameGrid[row][col].getRight()==false && lava[row][col+1]==0){
      possible.add("right");
    }
    if(row-1>=0 && gameGrid[row][col].getTop()==false && lava[row-1][col]==0){
      possible.add("up");
    }
    if(row+1<(int)(wid) && gameGrid[row][col].getBottom()==false && lava[row+1][col]==0){
      possible.add("down");
    }
    return possible;
  }


void drawOutlines(cell x, int rnum, int cnum, boolean tf){ // draws outlines
      if(x.getLeft()==tf){
        line(cnum*cellWidth, rnum*cellWidth, cnum*cellWidth, rnum*cellWidth+cellWidth);
      }
      if(x.getRight()==tf){
        line(cnum*cellWidth+cellWidth, rnum*cellWidth, cnum*cellWidth+cellWidth, rnum*cellWidth+cellWidth);
      }
      if(x.getTop()==tf){
        line(cnum*cellWidth, rnum*cellWidth, cnum*cellWidth+cellWidth, rnum*cellWidth);
      }
      if(x.getBottom()==tf){
        line(cnum*cellWidth, rnum*cellWidth+cellWidth , cnum*cellWidth+cellWidth, rnum*cellWidth+cellWidth);
      }
}

void keyPressed(){
  if(movable==true){ // checks if player can move in the selected direction
    if(keyCode==UP && gameGrid[prow][pcol].getTop()==false && prow-1>=0){
      if(drawn[prow-1][pcol]==true){
        drawn[prow][pcol]=false;
      }
      else{
        drawn[prow-1][pcol]=true;
      }
      prow--;
    }
    if(keyCode==DOWN && gameGrid[prow][pcol].getBottom()==false && prow+1<gameGrid.length){
      if(drawn[prow+1][pcol]==true){
        drawn[prow][pcol]=false;
      }
      else{
        drawn[prow+1][pcol]=true;
      }
      prow++;
    }
    if(keyCode==LEFT && gameGrid[prow][pcol].getLeft()==false && pcol-1>=0){
      if(drawn[prow][pcol-1]==true){
        drawn[prow][pcol]=false;
      }
      else{
        drawn[prow][pcol-1]=true;
      }
      pcol--;
    }
    if(keyCode==RIGHT && gameGrid[prow][pcol].getRight()==false && pcol+1<gameGrid.length){
      if(drawn[prow][pcol+1]==true){
        drawn[prow][pcol]=false;
      }
      else{
        drawn[prow][pcol+1]=true;
      }
      pcol++;
    }
  }
}
  
  
class lavaMaze{
  boolean[][] visited;
  cell[][] grid;
  cell start;
  cell end;
  
  lavaMaze(int mazeSize){
    grid = new cell[mazeSize][mazeSize];
    visited = new boolean[mazeSize][mazeSize];
    for(int r=0; r<mazeSize; r++){ // initializes board
      for(int c=0; c<mazeSize; c++){
        visited[r][c]=false;
        cell x = new cell(1,1,1,1, r,c);
        grid[r][c]=x;
      }
    }
  }
  
  boolean[][] getVisited(){
    return visited;
  }
  
  cell[][] getGrid(){
    return grid;
  }
 
  Stack<cell> cells= new Stack<cell>();
  
  boolean path(int r, int c) { // creates the path recursively
    visited[r][c]=true;
    if(bFilled(visited)==true) {
      return true;
    }
    else{
        ArrayList<String> p = new ArrayList<String>();
        p=getPossibleDirections(r,c);
        int x=(int)(Math.random()*p.size());
        cells.push(grid[r][c]);
        if(p.size()!=0){
          String dir = p.get(x);
          if(dir.equals("left")){
            grid[r][c].setLeft(0);
            grid[r][c-1].setRight(0);
            path(r,c-1);
          }
          if(dir.equals("right")){
            grid[r][c].setRight(0);
            grid[r][c+1].setLeft(0);
            path(r,c+1);
          }
          if(dir.equals("up")){
            grid[r][c].setTop(0);
            grid[r-1][c].setBottom(0);
            path(r-1,c);
          }
          if(dir.equals("down")){
            grid[r][c].setBottom(0);
            grid[r+1][c].setTop(0);
            path(r+1,c);
          }
        }
        else {
          cells.pop();
          r=cells.get(cells.size()-1).cellRow;
          c=cells.get(cells.size()-1).cellCol;
          p=getPossibleDirections(r,c);
          while(p.size()==0) {
            cells.pop();
            r=cells.get(cells.size()-1).cellRow;
              c=cells.get(cells.size()-1).cellCol;
            p=getPossibleDirections(r,c);
          }
          path(r,c);
       }  
    }
    return false;
  }

  void startEnd(){ // randomly initializes start and end squares
    int wallStart = (int)(Math.random()*4);
    int wallEnd = (int)(Math.random()*4);
    while(wallStart==wallEnd){
      wallEnd = (int)(Math.random()*4);
    }
    int[] startcoords = startf(wallStart, (int)(Math.random()*grid.length));
    int []endcoords = startf(wallEnd, (int)(Math.random()*grid.length));
    start = grid[startcoords[0]][startcoords[1]];
    end = grid[endcoords[0]][endcoords[1]];
  }

  int[] startf(int side, int square){ // removes walls from 
  //start and end squares and returns location for initialization
  //in startEnd function
    if(side==0){
      grid[0][square].setTop(0);
      return new int[] {0, square};
    }
    else if(side==1){
      grid[square][0].setLeft(0);
      return new int[] {square, 0};
    }
    else if(side==2){
      grid[grid.length-1][square].setBottom(0);
      return new int[] {grid.length-1, square};
    }
    else{
      grid[square][grid.length-1].setRight(0);
      return new int[] {square, grid.length-1};
    }
  }
  
  cell getStart(){
    return start;
  }
  
  cell getEnd(){
    return end;
  }

  ArrayList<String> getPossibleDirections(int row, int col){ // returns possible directions 
  //when forming path
    ArrayList<String> possible = new ArrayList<String>();
    if(col-1>=0 && visited[row][col-1]==false){
      possible.add("left");
    }
    if(col+1< grid[0].length && visited[row][col+1]==false){
      possible.add("right");
    }
    if(row+1<grid.length && visited[row+1][col]==false){
      possible.add("down");
    }
    if(row-1>=0 && visited[row-1][col]==false){
      possible.add("up");
    }
    return possible;
  }
  
  boolean bFilled(boolean[][] x) { // checks if boolean 
  //array x is filled with trues
    int count=0;
    for(int r=0; r<x.length; r++) {
      for(int c=0; c<x[r].length; c++) {
        if(x[r][c]==true) {
          count++;
        }
      }
    }
    if(count==x.length*x[0].length) {
      return true;
    }
    return false;
  }
}

class cell{
  
  int cellRow;
  int cellCol;
  boolean leftWall;
  boolean rightWall;
  boolean topWall;
  boolean bottomWall;
  boolean[] walllist = {leftWall, rightWall, topWall, bottomWall};

  cell(int lw, int rw, int tw, int bw, int ro, int co){ //initializes cell
  //1 means wall is present on specified side, 0 means no wall is present
    int[] ws = {lw, rw, tw, bw};
    for(int i=0; i<4; i++){
      if(ws[i] == 1){
        walllist[i] = true;
      }
      else{
        walllist[i] = false;
      }
    }
    leftWall = walllist[0];
    rightWall = walllist[1];
    topWall = walllist[2];
    bottomWall = walllist[3];
    cellRow=ro;
    cellCol=co;
  }
  
  int cellRow(){
    return cellRow;
  }
  
  int cellCol(){
    return cellCol;
  }
  
  boolean getLeft(){
    return leftWall;
  }
  
  boolean getRight(){
    return rightWall;
  }
  
  boolean getTop(){
    return topWall;
  }
  
  boolean getBottom(){
    return bottomWall;
  }
  
  void setLeft(int x){
    if(x==1){
      leftWall=true;
    }
    else{
      leftWall=false;
    }
  }
  
  void setRight(int x){
    if(x==1){
      rightWall=true;
    }
    else{
      rightWall=false;
    }
  }
  
  void setTop(int x){
    if(x==1){
      topWall=true;
    }
    else{
      topWall=false;
    }
  }
  
  void setBottom(int x){
    if(x==1){
      bottomWall=true;
    }
    else{
      bottomWall=false;
    }
  }
}
