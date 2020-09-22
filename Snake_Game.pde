final int screen_width = 800;
final int screen_height = 600;
final int base_framerate = 10;
final int cell_size = 20;
final int grid_width = screen_width/cell_size;
final int grid_height = screen_height/cell_size;
final int APPLE_CELL = 2;
final int SNAKE_CELL = 1;
final int EMPTY_CELL = 0;
boolean isPaused = false;
Grid grid = new Grid(grid_width, grid_height);
Apple apple = new Apple(); 
Snake snake = new Snake();
Vector direction = new Vector(0, 0);


void setup(){
  size(800, 600);
  frameRate(base_framerate);
  surface.setResizable(false);
  noStroke();
  grid.create();
}


void draw(){
  background(0);
  showScore(snake.bodies.length);
  if(!isPaused)
    update();
  apple.drawInstance();
  snake.drawInstance();
  //grid.debug();
}


void update(){
  if(direction.x==0 && direction.y==0)
    return;
  snake.move(direction);
}

void keyPressed(){
  if(key == CODED && !isPaused){
    if(keyCode == RIGHT && direction.x != -1){
      direction = new Vector(1,0);
    }else if(keyCode == LEFT && direction.x != 1){
      direction = new Vector(-1,0);
    }else if (keyCode == UP && direction.y != 1){
      direction = new Vector(0,-1);
    }else if (keyCode == DOWN && direction.y != -1){
      direction = new Vector(0,1);
    }
  }else{
    if (key == 'r'){
      println("Restarting the game...");
      restartGame();
    }
    if (key == 'p'){
      pauseGame();
    }
  }
}


void showScore(int score){
  fill(75);
  textSize(256);
  text(score, screen_width/2-64, screen_width/2);
}


void pauseGame(){
  isPaused = !isPaused;
  if(isPaused)println("Game paused.");
  else println("Game resumed.");
}


void restartGame(){
  snake = new Snake();
  apple.spawn();
  direction = new Vector();
  frameRate(base_framerate);
  grid.create();
}



class Vector{
  int x;
  int y;
  
  public Vector(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public Vector(){
    this.x = 0;
    this.y = 0;
  }
}



class Snake{
  Vector position;
  Vector direction;
  Vector bodies[] = new Vector[0];
  int body_length = 1;
  
  public Snake(){
    this.position = new Vector();
    this.position.x = (int)random(0,grid_width);
    this.position.y = (int)random(0,grid_height);
    this.direction = new Vector();
  }
  
  void expand_body(){
    Vector [] new_body = new Vector[snake.bodies.length+1];
    if(snake.bodies.length>0)new_body[new_body.length-1] = snake.bodies[snake.bodies.length-1];
    else new_body[new_body.length-1] = this.position;
    for(int i=0;i<snake.bodies.length;i++){
      new_body[i] = snake.bodies[i];
    }
    snake.bodies = new Vector[new_body.length];
    snake.bodies = new_body;
    
  }
  
  void move(Vector direction){
    grid.content[this.position.x][this.position.y] = EMPTY_CELL;
    if(bodies.length>0){
       for(int i=0 ; i<snake.bodies.length ; i++){
         grid.content[snake.bodies[i].x][snake.bodies[i].y] = EMPTY_CELL;
       }
       for(int i=snake.bodies.length-1 ; i>=0 ; i--){
         if(i==0) snake.bodies[0] = this.position;
         else{
           snake.bodies[i] = snake.bodies[i-1];
         }
         grid.content[snake.bodies[i].x][snake.bodies[i].y] = SNAKE_CELL;
       }
       
    }
    
    Vector next_position = new Vector(this.position.x+direction.x, this.position.y+direction.y);
    /*if(next_position.x >= grid.columns)next_position.x = 0;
    else if(next_position.x<0) next_position.x = grid_width-1;
    if(next_position.y >= grid.rows)next_position.y = 0;
    else if(next_position.y<0) next_position.y = grid_height-1;*/
    
    if((next_position.x >= grid.columns) || (next_position.x<0) || (next_position.y >= grid.rows) || (next_position.y<0)){
      restartGame();
      return;
    }
    
    this.position = next_position;
    
    if(grid.content[next_position.x][next_position.y] == SNAKE_CELL){
      restartGame();
    }
    
    if(grid.content[this.position.x][this.position.y] == APPLE_CELL){
      body_length++;
      this.expand_body();
      apple.spawn();
      int fps = floor(base_framerate + cell_size/10 *log(this.body_length));
      frameRate(fps);
    }
    
    grid.content[this.position.x][this.position.y] = SNAKE_CELL;
  }
  
  void drawInstance(){
    fill(0, 255, 0);
    rect(this.position.x*cell_size, this.position.y*cell_size, cell_size, cell_size);
    grid.content[this.position.x][this.position.y] = SNAKE_CELL;
    if(this.bodies.length>0){
      for(int i=0 ; i<this.bodies.length ; i++){
        int green = 255 - i*20;
        green = constrain(green, 100, 255);
        fill(0, green, 0);
        rect(this.bodies[i].x*cell_size, this.bodies[i].y*cell_size, cell_size, cell_size);
      }
    }
  }
  
}



class Apple{
  Vector position;
  
  public Apple(){
    this.position = new Vector();
    this.spawn();
  }
  
  void spawn(){
    this.position = new Vector((int)random(1, grid_width-1),(int)random(1, grid_height-1));
    grid.content[this.position.x][this.position.y] = APPLE_CELL;
  }
  
  void drawInstance(){
    fill(255,0,0);
    rect(this.position.x*cell_size, this.position.y*cell_size, cell_size, cell_size);
    grid.content[this.position.x][this.position.y] = APPLE_CELL;
  }
}



class Grid{
  int columns;
  int rows;
  int [][] content;
  
  public Grid(int columns, int rows){
    this.columns = columns;
    this.rows = rows;
    this.content = new int[columns][rows];
    this.create();
  }
  
  void create(){
    for(int j=0 ; j<this.rows ; j++){
      for(int i=0 ; i<this.columns ; i++){
        this.content[i][j] = 0;
      }
    }
  }
  
  void debug(){
  textSize(12);
  fill(255);
  for(int i=0 ; i<this.columns ; i++){
    for(int j=0 ; j<this.rows ; j++){
      text(grid.content[i][j], i*cell_size + cell_size/2, j*cell_size + cell_size/2);
    }
  }
}
  
}
