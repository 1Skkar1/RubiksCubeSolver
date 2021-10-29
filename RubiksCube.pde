import peasy.*;

PeasyCam cam;

float speed = 0.1;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

Move[] allMoves = new Move[] {
  new Move(0, 1, 0, 1), 
  new Move(0, 1, 0, -1), 
  new Move(0, -1, 0, 1), 
  new Move(0, -1, 0, -1), 
  new Move(1, 0, 0, 1), 
  new Move(1, 0, 0, -1), 
  new Move(-1, 0, 0, 1), 
  new Move(-1, 0, 0, -1), 
  new Move(0, 0, 1, 1), 
  new Move(0, 0, 1, -1), 
  new Move(0, 0, -1, 1), 
  new Move(0, 0, -1, -1),
};

ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;
int timesPressed = 0;
boolean started = false;

Move currentMove;

void setup() {
  size(600, 600, P3D);
  //fullScreen(P3D);
  cam = new PeasyCam(this, 400);
  int index = 0;
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);
        index++;
      }
    }
  }
  int nMoves = int(random(25, 200));
  for (int i = 0; i < nMoves; i++) {
    int r = int(random(allMoves.length));
    Move m = allMoves[r];
    sequence.add(m);
  }

  currentMove = sequence.get(counter);

  for (int i = sequence.size()-1; i >= 0; i--) {
    Move nextMove = sequence.get(i).copy();
    nextMove.reverse();
    sequence.add(nextMove);
  }

  currentMove.start();
}

void restart() {
  speed = 0.1;
  sequence = new ArrayList<Move>();
  counter = 0;
  timesPressed = 0;
  started = false;
  setup();
}

void keyPressed() {
  if(key == ' ') {
    started = true; 
  }
  if(key == 'r' || key == 'R') {
    restart();
  }
  if(key == BACKSPACE) {
    speed = 0.1;
    timesPressed = 0;
  }
  if(key == ENTER && timesPressed == 0) {
    speed = 0.25;
    timesPressed++;
  }
  else if(key == ENTER && timesPressed > 0) {
    speed = 0.5;
  }
}

void draw() {
  background(51); 

  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 25, 50);
  textSize(15);
  fill(0,255,0);
  text("> ENTER to speed up", 10, 570);
  fill(255,0,0);
  text("> BACKSPACE to slow down", 10, 590);
  fill(255);
  text("> R to restart", 10, 550);
  cam.endHUD();

  rotateX(-0.5);
  rotateY(0.4);
  rotateZ(0.1);
  currentMove.update();
  if (currentMove.finished()) {
    if (counter < sequence.size()-1) {
      counter++;
      currentMove = sequence.get(counter);
      currentMove.start();
    }
  }
  scale(50);
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == currentMove.z) {
      rotateZ(currentMove.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == currentMove.x) {
      rotateX(currentMove.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y ==currentMove.y) {
      rotateY(-currentMove.angle);
    }   
    cube[i].show();
    pop();
  }
}
