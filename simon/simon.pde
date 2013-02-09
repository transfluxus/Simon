import java.util.Collections;

color[] playerClr= new color[2];
Rect[] rects;

int millis, blinkTime=200;

int[] playerKeyCount = new int[2];

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

  playerKeyCount[1] = int(totalGridSz/2;
  playerKeyCount[2] = totalGridSz - playerKeyCount[1];
  for (int i=0;i < totalGridSz;i++) 
    if (i<totalGridSz/2)
      g.add(1);
    else
      g.add(2);
  Collections.shuffle(g);
  for (int i=0;i < totalGridSz;i++) {
	float size = 0.2 + random(0.8);
    rects[i] = new Rect(gridPoints[i], g.get(i), playerClr[g.get(i)-1], size);
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
  float size;
 
  Rect(  PVector pos, int player, color clr, float size) {
    this.pos = pos;
    this.player= player;
    this.clr = clr;
    this.size = size;
  }

  void x() {
	return pos.x + rectSz*0.5*(1-size);
  }

  void y() {
	return pos.y + rectSz*0.5*(1-size);
  }
  void width() {
	return rectSz * size;
  }
  void height() {
	return rectSz * size;
  }

  void draw() {
    stroke(clr);
    if (blink)
      fill(clr);
      else noFill();
    rect(x(),y(),width(),height());
    if(millis-blinkStartTime>blinkTime);
      blink=false;
  }

  void blink() {
    blink=true;
    blinkStartTime = millis;
  }
}


