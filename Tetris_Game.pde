Grid grid = new Grid(10, 20);

void setup(){
  size(301, 601);
  background(0);
  frameRate(30);
  grid.content[0][0] = 1;
}

void draw(){
  background(0);
  grid.drawInstance();
}

void update(){
  
}

void keyPressed(){
  if(keyCode == CODED){
    if(keyCode == RIGHT){
      
    }else if (keyCode == LEFT){
      
    }else if (keyCode == DOWN){
      
    }
  }
}

void keyReleased(){
  if(keyCode == CODED){
    if(keyCode == UP){
      
    }
  }
}

class Grid{
  int cols, rows;
  int content[][];
  int cell_size = 30;
  public Grid(int cols, int rows){
    this.cols = cols;
    this.rows = rows;
    this.content = new int[cols][rows];
    this.fillContent(0);
  }
  
  void fillContent(int value){
    for(int j = 0 ; j<this.rows ; j++){
      for(int i = 0 ; i<this.cols ; i++){
        this.content[i][j] = value;
      }
    }
  }
  
  int getCell(int col, int row){
    return this.content[col][row];
  }
  
  int getCell(Vector position){
    return this.content[position.x][position.y];
  }
  
  void setCell(Vector position, int value){
    this.content[position.x][position.y] = value;
  }
  
  void setCell(int col, int row, int value){
    this.content[col][row] = value;
  }
  
  void drawInstance(){
    fill(255);
    
    this.drawLines();
    for(int j = 0 ; j<this.rows ; j++){
      if(j!=0)line(0, j*cell_size, this.rows*cell_size, j*cell_size);
      for(int i = 0 ; i<this.cols ; i++){
        if(i!=0)line(i*cell_size, 0, i*cell_size, this.rows*cell_size);
        if(getCell(i, j) == 1)
          square(i * cell_size, j * cell_size, cell_size);
      }
    }
  }
  
  void drawLines(){
    stroke(200);
    for(int j = 0 ; j<=this.rows ; j++){
      line(0, j*cell_size, this.rows*cell_size, j*cell_size);
      for(int i = 0 ; i<=this.cols ; i++){
        line(i*cell_size, 0, i*cell_size, this.rows*cell_size);
      }
    }
  }
}


class Vector{
  int x,y;
  public Vector(int x, int y){
    this.x = x;
    this.y = y;
  }
}
