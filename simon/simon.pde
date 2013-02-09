import java.util.Collections;

color player1Clr, player2Clr;
Rect[] rects;

void setup() {
  size(displayWidth, displayHeight);
  player1Clr= color(255, 0, 0);
  player2Clr=color(0, 0, 255);
  initBoard();
}

void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();
  for (int i=0;i < totalGridSz;i++) 
    g.add(i);
  Collections.shuffle(g);

  for (int i=0;i < totalGridSz;i++) {
    if (i<totalGridSz/2)
      rects[i] = new Rect(gridPoints[i], 1,player1Clr);
    else
      rects[i] = new Rect(gridPoints[i], 2,player2Clr);
    //    playerG[i] = random(1)<0.5;
    // PVector pos = new PVector(cos(i*div )*r, sin(i* div)*r);
    //   balls.add(new Ball(i, pos));
  }
}


void draw() {
  background(0);
  for (int i=0;i < totalGridSz;i++) {
    rects[i].draw();
  }
}

class Rect {

  PVector pos;
  int player; 
 color clr;
 
  Rect(  PVector pos, int player,color clr) {
    this.pos = pos;
    this.player= player;
    this.clr = clr;
  }
  
  void draw() {
    
  }
}

