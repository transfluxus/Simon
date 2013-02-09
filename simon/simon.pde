import java.util.Collections;

color[] playerClr= new color[2];
Rect[] rects;

int millis, blinkTime=200;

void setup() {
  size(displayWidth, displayHeight);
  playerClr[0]= color(255, 0, 0);
  playerClr[1]=color(0, 0, 255);
  initBoard();
}

void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();
  for (int i=0;i < totalGridSz;i++) 
    if (i<totalGridSz/2)
      g.add(1);
    else
      g.add(2);
  Collections.shuffle(g);
  for (int i=0;i < totalGridSz;i++) {

    rects[i] = new Rect(gridPoints[i], g.get(i), playerClr[g.get(i)-1]);
  }
}


void draw() {
  background(0);
  for (int i=0;i < totalGridSz;i++) {
    rects[i].draw();
  }
  millis = millis();
}

class Rect {

  PVector pos;
  int player; 
  color clr;
  boolean blink;
  int blinkStartTime;

  Rect(  PVector pos, int player, color clr) {
    this.pos = pos;
    this.player= player;
    this.clr = clr;
  }

  void draw() {
    stroke(clr);
    if (blink)
      fill(clr);
      else noFill();
    rect(pos.x, pos.y, rectSz, rectSz);
    if(millis-blinkStartTime>blinkTime);
      blink=false;
  }

  void blink() {
    blink=true;
    blinkStartTime = millis;
  }
}


