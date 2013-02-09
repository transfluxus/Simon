import java.util.Collections;

color[] playerClr= new color[2];
Rect[] rects;

int millis, blinkTime=100;

int[] playerKeyCount = new int[2];

void setup() {
  size(displayWidth, displayHeight);
  playerClr[0]= color(255, 0, 0);
  playerClr[1]=color(0, 0, 255);
  initBoard();
  strokeWeight(8);
}

void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();

  playerKeyCount[0] = int(totalGridSz/2);
  playerKeyCount[1] = totalGridSz - playerKeyCount[0];
  for (int i=0;i < totalGridSz;i++) 
    if (i<totalGridSz/2)
      g.add(1);
    else
      g.add(2);
  Collections.shuffle(g);
  for (int i=0;i < totalGridSz;i++) {
    float size = 0.8f;//0.2 + random(0.8);
    rects[i] = new Rect(gridPoints[i], g.get(i), playerClr[g.get(i)-1], size, i);
  }
}


void draw() {
  background(0);
  for (int i=0;i < totalGridSz;i++) {
    rects[i].draw();
  }
  millis = millis();
}

void mousePressed() {
  PVector mouse = new PVector(mouseX, mouseY);
  for (int i=0;i < totalGridSz;i++) 
    if (rects[i].pressed(mouse)) {
      process(rects[i]);
      return;
    }
}

void process(Rect rect) {
  println(rect.player+ " "+rect.id);
  rect.blink();
}

class Rect {

  PVector pos;
  int player; 
  color clr;
  boolean blink;
  int blinkStartTime;
  float size;
  int id;

  Rect(PVector pos, int player, color clr, float size, int id) {
    this.pos = pos;
    this.player= player;
    this.clr = clr;
    this.size = size;
    this.id = id;
  }

  float x() {
	return pos.x + rectSz*0.5*(1-size);
  }

  float y() {
	return pos.y + rectSz*0.5*(1-size);
  }
  float width() {
	return rectSz * size;
  }
  float height() {
	return rectSz * size;
  }

  void draw() {
    stroke(clr);
    if (blink)
      fill(clr);
    else noFill();
    int t = blinkTime - (millis-blinkStartTime);
      if (t<0) {
        blink=false;
        size=0.8f;
      }
//      else
//      size = sin(map(blinkTime-t))
    //    size = 0.8f* sin(t/blinkTime * 
    rect(x(), y(), width(), height(), 10);
  }

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }


  void blink() {
    blink=true;
    blinkStartTime = millis;
  }
}

