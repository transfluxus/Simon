import java.util.Collections;

color[] playerClr= new color[2];
Rect[] rects;
Sequence[] sequences = new Sequence[2];
SequenceAnimation[] sequenceAnimations = new SequenceAnimation[2];

int millis;

int[] playerKeyCount = new int[2];

void setup() {
  size(displayWidth, displayHeight);
  playerClr[0]= color(252, 156, 41);
  playerClr[1]= color(185, 249, 61);
  // 255, 3, 3
  initBoard();
  initSequences();
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

void createSequence(int player) {
    sequences[player] = new Sequence(3, playerKeyCount[player]);
    sequenceAnimations[player] = new SequenceAnimation(sequences[player], player+1);
}


void initSequences() {
  for (int i = 0; i < 2; i++) {
      createSequence(i);
  }
}

//void update() {
//}

void draw() {
  //update();
  int i;
  background(0);
  // backwards update because we might delete in-place
  for (i = sequenceAnimations.length-1; i >= 0; i--)
	sequenceAnimations[i].update();

  for (i=0;i < totalGridSz;i++) {
    rects[i].draw();
  }
  millis = millis();
}

void mousePressed() {
  int i;
  PVector mouse = new PVector(mouseX, mouseY);

// test: generate sequence
//  int p = (int)random(2);
//  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  for (i=0;i < totalGridSz;i++) 
    if (rects[i].pressed(mouse)) {
      process(rects[i]);
      return;
    }
}


void process(Rect rect) {
  int pl = rect.player - 1;
  if (sequenceAnimations[pl].playing())
    return;
  
  Sequence seq = sequences[pl];
  if (seq.validKey(rect.id)) {
       rect.showTouched();
       if (seq.completed()) {
         //for (int i=0; i<rects.length; i++)
         //  if (rects[i].player == rect.player)
         //    rects[i].showSuccess();
         rect.showSuccess();
         createSequence(pl);
       }
  } else {
    rect.showFail();
    createSequence(pl);
  }
}

int rectIndex(int player, int id) {
  for (int i=0; i<rects.length; i++) {
    if (rects[i].player == player && rects[i].id == id)
      return i;
  }
  // error!
  return -1;
}

