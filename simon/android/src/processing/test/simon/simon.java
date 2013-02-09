package processing.test.simon;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class simon extends PApplet {



int[] playerClr= new int[2];
Rect[] rects;
Sequence[] sequences = new Sequence[2];
SequenceAnimation[] sequenceAnimations = new SequenceAnimation[2];

int millis;

int[] playerKeyCount = new int[2];

public void setup() {
 
  orientation(LANDSCAPE);
  playerClr[0]= color(252, 156, 41);
  playerClr[1]= color(185, 249, 61);
  // 255, 3, 3
  initBoard();
  initSequences();
  strokeWeight(8);
}

public void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();

  playerKeyCount[0] = PApplet.parseInt(totalGridSz/2);
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

public void createSequence(int player) {
    sequences[player] = new Sequence(4, playerKeyCount[player]);
    sequenceAnimations[player] = new SequenceAnimation(sequences[player], player+1);
}


public void initSequences() {
  for (int i = 0; i < 2; i++) {
      createSequence(i);
  }
}

//void update() {
//}

public void draw() {
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

public void mousePressed() {
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


public void process(Rect rect) {
  int pl = rect.player - 1;
  if (sequenceAnimations[pl].playing())
    return;
  
  Sequence seq = sequences[pl];
  if (seq.validKey(rect.id)) {
       rect.showTouched();
       if (seq.completed()) {
         //allRectsSuccess(rect.player);
         rect.showSuccess();
         createSequence(pl);
       }
  } else {
    rect.showFail();
    //allRectsFail(rect.player);
    createSequence(pl);
  }
}

public int rectIndex(int player, int id) {
  for (int i=0; i<rects.length; i++) {
    if (rects[i].player == player && rects[i].id == id)
      return i;
  }
  // error!
  return -1;
}

public void allRectsSuccess( int player ) {
   for (int i=0; i<rects.length; i++)
      if (rects[i].player == player)
          rects[i].showSuccess();
}

public void allRectsFail( int player ) {
   for (int i=0; i<rects.length; i++)
      if (rects[i].player == player)
          rects[i].showFail();
}
int blinkTime=300;
float defaultSize = 0.97f;

class Rect {

  PVector pos;
  int player; 
  int baseColor;
  int clr;
  int borderClr;
  boolean touched;
  boolean success;
  boolean fail;
//  int blinkStartTime;
  int time;
  float size;

  int id;

  Rect(PVector pos, int player, int clr, float size, int id) {

    this.pos = pos;
    this.player= player;
    this.baseColor = clr;
    this.clr = clr;
    this.borderClr = clr;
    this.size = size;
    this.id = id;
  }

  public float x() {
  return pos.x + rectSz*0.5f*(1-size);
  }

  public float y() {
  return pos.y + rectSz*0.5f*(1-size);
  }
  public float width() {
  return rectSz * size;
  }
  public float height() {
  return rectSz * size;
  }
  
  public void resetColors() {
    this.touched = false;
    this.success = false;
    this.fail = false;
    this.time = 0;
  }
  
  public void updateColors() {
    int currentTime = millis;
    float baseShade = 0.7f;
    if (currentTime <= time) {
      if (fail) {
        //clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
        clr = color(255, 3, 3);
      } else if (success) {
        //clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
        clr = color(199, 249, 102); //color(3,255,3);
      } else if (touched) {
        float timeFraction = (time-currentTime)/(float)blinkTime;
        float colorFraction = baseShade + (1-baseShade) * pow(timeFraction,0.1f);
        clr = color(red(baseColor) * colorFraction, green(baseColor) * colorFraction, blue(baseColor) * colorFraction);
        borderClr = clr;
      }
    } else {
      resetColors();
      clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
      borderClr = clr;
    }

  
  }

  public void draw() {
    updateColors();
    fill(clr);
    //stroke(borderClr);
    //if (blink)
    //  fill(clr);
    //else noFill();

    //int t = blinkTime - (millis-blinkStartTime);
    //  if (t<0) {
    //    blink=false;
    //    size=defaultSize;
    //  }
    //  else
    //  size = defaultSize+(1-defaultSize)*sin(map(blinkTime-t,0,blinkTime,0,PI));
    //    size = 0.8f* sin(t/blinkTime * 
    rect(x(), y(), width(), height());
  }

  public boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }

  public void resetTimer() {
    this.time = millis + blinkTime;
  }

  public void showTouched() {
    touched = true;
    resetTimer();
  }
  
  public void showSuccess() {
    success = true;
    resetTimer();
  }
  
  public void showFail() {
    fail = true;
    resetTimer();
  }
}
int w, h;

//int totalrectSz = 0.8f;
int gridW = 4, gridH = 3, totalGridSz = gridW*gridH;
PVector[] gridPoints = new PVector[gridW*gridH];

int rectSz ;
int xoff;

public void calcGrid() {
  rectSz = displayHeight / gridH;
  xoff = (int)(displayWidth * 0.5f - gridW * rectSz * 0.5f);
  for(int x= 0; x < gridW; x++) {
    for(int y=0; y <gridH; y++) {
      gridPoints[x+y*gridW] = new PVector(xoff + x*rectSz,y*rectSz);
    }
  }
}


class Sequence {
  ArrayList<Integer> seq = new ArrayList<Integer>();
  int index;
  boolean failed;

  Sequence( int len, int keycount ) {
	index = 0;
	failed = false;
	for (int i = 0; i<len; i++)
		seq.add(PApplet.parseInt(random(keycount)));
  }

  public int length() { return seq.size(); }

  // when user presses call this
  public boolean validKey(int newKey) {
	if (failed || index >= seq.size())
		return false;
	boolean success = (newKey == seq.get(index));
	if (success)
                index = index + 1;
	else
		failed = true;
        
	return success;
  }

  // what is the user score
  public int score() { return index; }
  
  // if the sequence was successfully completed
  public boolean completed() { return (index == length()) && !failed; }

  // for showing it
  public int getKey(int ndx) {
	return seq.get(ndx);
  }
}

int sequenceStepTime = 500;
int sequenceStartTime = 1200;
class SequenceAnimation {
  Sequence seq;
  int owner;
  int index;
  int switchTime;
  int timer;
  boolean done;
  SequenceAnimation( Sequence seq, int player ) {
      this.seq = seq;
      this.owner = player;
      this.index = 0;
      this.switchTime = millis + sequenceStartTime;
      this.done = false;
  }
  
  // returns true when anim finished
  public boolean update() {
    if (done) return true;
     boolean blink = false;
     
     if (millis >= switchTime) {
		blink = true;
		switchTime += sequenceStepTime;
	}

	if (blink) {
		int rectI = seq.getKey(index);
                rects[rectIndex(owner, rectI)].showTouched();
		index++;
		if (index == seq.length())
			done = true;
	}
	return done;
  }
  
  public boolean playing() { return !done; }

}

  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
}
