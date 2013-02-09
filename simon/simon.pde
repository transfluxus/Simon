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


