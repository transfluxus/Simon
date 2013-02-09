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



//color[] playerClr= new color[2];
Rect[] rects;
Sequence[] sequences = new Sequence[4];
SequenceAnimation[] sequenceAnimations = new SequenceAnimation[4];

int millis;

//int[] playerKeyCount = new int[2];
//int[] playerScore = new int[2];

Player [] players = new Player[4];

int limitTime = 0;
int fadeTime = 1000;
int waitTime = 3000;
int gameplayLength = 100000; //45000;
int winner = 0;
int playerCount = 2;

int gameState = 0;
// states: 0 - menu, 1 - game, 2 - end

public void setup() {
 
  orientation(LANDSCAPE);
  //playerClr[0]= color(252, 156, 41);
  //playerClr[1]= color(185, 249, 61);
  // 
  
  // 255, 3, 3
  initPlayers();
  initBoard();
  initSequences();
  strokeWeight(8);
}

public void initPlayers() {
  //Player(color normal, color right, color wrong, color show, color press)
  //players[0] = new Player(color(255, 255, 38), color(255, 255, 204), color(255, 3, 3), color(255, 253, 179), color(102, 102, 15));
  //players[1] = new Player(color(255, 38, 128), color(255, 204, 225), color(255, 3, 3), color(255, 89, 158), color(102, 15, 51));
  //players[2] = new Player(color(38, 204, 255), color(204, 243, 255), color(255, 3, 3), color(89, 216, 255), color(15, 82, 102));
  //players[3] = new Player(color(110, 255, 38), color(221, 255, 204), color(255, 3, 3), color(144, 255, 89), color(44, 102, 15));
  
  
  //players[0] = new Player(color(255, 255, 38), color(255, 253, 179), color(102, 102, 15), color(255, 253, 179), color(255, 253, 179));
  //layers[1] = new Player(color(255, 38, 128), color(255, 179, 210), color(102, 15, 51), color(255, 179, 210), color(255, 179, 210));
 //players[2] = new Player(color(38, 204, 255), color(128, 225, 255), color(15, 82, 102), color(128, 225, 255), color(128, 225, 255));
 // players[3] = new Player(color(110, 255, 38), color(204, 255, 179), color(44, 102, 15), color(204, 255, 179), color(204, 255, 179));
  
  players[0] = new Player(color(255, 255, 38), color(255, 253, 179), color(0, 0, 0), color(255, 253, 179), color(255, 253, 179));
  players[1] = new Player(color(255, 38, 128), color(255, 179, 210), color(0, 0, 0), color(255, 179, 210), color(255, 179, 210));
  players[2] = new Player(color(38, 204, 255), color(128, 225, 255), color(0, 0, 0), color(128, 225, 255), color(128, 225, 255));
  players[3] = new Player(color(110, 255, 38), color(204, 255, 179), color(0, 0, 0), color(204, 255, 179), color(204, 255, 179));
  
  
  players[0].active = true;
  players[1].active = true;

}

public void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();

  players[0].squares = PApplet.parseInt(totalGridSz/2);
  players[1].squares = totalGridSz - players[0].squares;
  for (int i=0;i < totalGridSz;i++) 
    if (i<totalGridSz/2)
      g.add(1);
    else
      g.add(2);
  Collections.shuffle(g);

  int[] rectCount = new int[4];
  rectCount[0] = 0;
  rectCount[1] = 0;
  rectCount[2] = 0;
  rectCount[3] = 0;
  for (int i=0;i < totalGridSz;i++) {
    int playr = g.get(i);
  //  float size = defaultSize;//0.2 + random(0.8);
    rects[i] = new Rect(gridPoints[i], playr, defaultSize, rectCount[playr-1]);
    rectCount[playr-1]++;
  }
}

public void createSequence(int player) {
    print("squares "+players[player].squares);
    sequences[player] = new Sequence(4, players[player].squares);
    sequenceAnimations[player] = new SequenceAnimation(sequences[player], player+1);
    // special: disable 3 and 4 by now
    if (player>1)
      sequenceAnimations[player].done = true;
}


public void initSequences() {
  for (int i = 0; i < 4; i++) {
      createSequence(i);
  }
}

//void update() {
//}

public void restartGame() {
    // 45 seconds
    limitTime = millis + gameplayLength;
    setGameState(1);
    resetPlayers();
}

public void resetPlayers()
{
  for (int i=0; i<4; i++)
    players[i].reset();
}

public void draw() {
  millis = millis();
  if (limitTime == 0) {
    restartGame();
  }
  
  if (gameState == 1 || gameState == 2) {
  
    background(0);
    
    int i;
  
    if (gameState == 1) {
      // backwards update because we might delete in-place
      for (i = sequenceAnimations.length-1; i >= 0; i--)
    	sequenceAnimations[i].update();
    }
  
    for (i=0;i < totalGridSz;i++) {
      rects[i].draw();
    }
    
    if (millis > limitTime)
      setGameState(2);
    
  }
  if (gameState == 2) { // endgame
    // for some time, fade to black
    float fraction = (millis - limitTime)/(float)fadeTime;
    fill(0,0,0, 255.0f*fraction);
    rect(-100, -100, displayWidth + 200, displayHeight + 200);
    if (millis > limitTime + fadeTime)
      setGameState(3);
  }
  
  if (gameState == 3) {
     float fraction = (millis - limitTime - fadeTime)/(float)fadeTime;
     if (fraction > 1) fraction = 1;
     int winnerColor = players[winner].normal;
     fill(red(winnerColor),green(winnerColor),blue(winnerColor), 255*fraction);
     rect(-100, -100, displayWidth + 200, displayHeight + 200);
     // SHOW NUMBER?
  }
}

public void mousePressed() {
  int i;
  PVector mouse = new PVector(mouseX, mouseY);

// test: generate sequence
//  int p = (int)random(2);
//  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  if (gameState == 1) {
    for (i=0;i < totalGridSz;i++) 
      if (rects[i].pressed(mouse)) {
        process(rects[i]);
        return;
      }
  } else if (gameState == 3 && millis > limitTime + 2 * fadeTime) {
      restartGame();
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
         allRectsSuccess(rect.player);
         //rect.showSuccess();
         players[pl].score++;
         createSequence(pl);
       }
  } else {
    //rect.showFail();
    allRectsFail(rect.player);
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

public void computeWinner() {
  winner = 0;
  int winnercount = players[0].score;
  for (int i = 1; i < playerCount; i++)
      if (players[i].score >= winnercount) {
          winnercount = players[i].score;
          winner = i;
      }
}

public void setGameState(int newState) {
  gameState = newState;
  
  if (newState == 2) {
    computeWinner();  
  }
}
class Player {
  int normal;
  int right;
  int wrong;
  int show;
  int press;
  
  boolean active;
  int score;
  int squares;
  
  
  Player(int normal, int right, int wrong, int show, int press)
  {
    this.normal = normal;
    this.right = right;
    this.wrong = wrong;
    this.show = show;
    this.press = press;
    reset();
  }
  
  public void reset() {
    active = false;
    score = 0;
    //squares = 0;
  }
  
  public void inc() {
    score++;
  }

}
int blinkTime=300;
float defaultSize = 0.97f;

class Rect {

  PVector pos;
  int player; 
  int clr;
  int time;
  float size;
  
  int state;
  // 0: normal, 1: pressed, 2: show, 3: success, 4: fail

  int id;

  Rect(PVector pos, int player, float size, int id) {

    this.pos = pos;
    this.player= player;
    this.size = size;
    this.id = id;
    this.state = 0;
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
    this.state = 0;
    this.time = 0;
  }
  
  public void updateColors() {
    if (millis > time)
      state = 0;
    
    if (state == 0)
      clr = players[player-1].normal;
    if (state == 1)
      clr = players[player-1].press;
    if (state == 2)
      clr = players[player-1].show;
    if (state == 3)
      clr = players[player-1].right;
    if (state == 4)
      clr = players[player-1].wrong;
  
  }

  public void draw() {
    updateColors();
    fill(clr);
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
    state = 1;
    resetTimer();
  }
  
  public void showSuccess() {
    state = 3;
    resetTimer();
  }
  
  public void showFail() {
    state = 4;
    resetTimer();
  }
  
  public void showShow() {
    state = 2;
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
                rects[rectIndex(owner, rectI)].showShow();
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
