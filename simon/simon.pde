import java.util.Collections;

color[] playerClr= new color[2];
Rect[] rects;
ArrayList<SequenceAnimation> sequenceAnimations = new ArrayList<SequenceAnimation>();

int millis;

int[] playerKeyCount = new int[2];

void setup() {
  size(displayWidth, displayHeight);
  playerClr[0]= color(252, 156, 41);
  playerClr[1]= color(185, 249, 61);
  // 255, 3, 3
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

  int[] rectCount = new int[2];
  rectCount[0] = 0;
  rectCount[1] = 0;
  for (int i=0;i < totalGridSz;i++) {
    int playr = g.get(i);
  //  float size = defaultSize;//0.2 + random(0.8);
    rects[i] = new Rect(gridPoints[i], playr, playerClr[playr-1], defaultSize, rectCount[playr-1]);
    rectCount[playr-1]++;
  }
}


void draw() {
  int i;
  background(0);
  // backwards update because we might delete in-place
  for (i = sequenceAnimations.size()-1; i >= 0; i--)
	if (sequenceAnimations.get(i).update())
		sequenceAnimations.remove(i);

  for (i=0;i < totalGridSz;i++) {
    rects[i].draw();
  }
  millis = millis();
}

void mousePressed() {
  int i;
  PVector mouse = new PVector(mouseX, mouseY);

// test: generate sequence
  int p = (int)random(2);
  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  if (false) {

  for (i=0;i < totalGridSz;i++) 
    if (rects[i].pressed(mouse)) {
      process(rects[i]);
      return;
    }
  }
}

void process(Rect rect) {

  println(rect.player+ " "+rect.id);
  rect.blink();

}

int rectIndex(int player, int id) {
  for (int i=0; i<rects.length; i++) {
    if (rects[i].player == player && rects[i].id == id)
      return i;
  }
  // error!
  return -1;
}

