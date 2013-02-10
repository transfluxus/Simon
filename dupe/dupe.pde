import java.util.Collections;
/* import ketai.ui.*;

KetaiGesture gesture;
*/
Rect[] rects;
Sequence[] sequences = new Sequence[4];
SequenceAnimation[] sequenceAnimations = new SequenceAnimation[4];

int millis;

Player [] players = new Player[4];

int limitTime = 0;
int fadeTime = 1000;
int waitTime = 3000;
int gameplayLength = 45000; //45000;
int winner = 0;
int playerCount = 1;

int gameState = -1;
// states: -1 - intro screen, 0 - color select/check ready, 1 - game, 2 - end

void setup() {
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);

//gesture = new KetaiGesture(this);

  initPlayers();
  initBoard();
  initMenu();
  //  restartGame();
  strokeWeight(8);
}

void initPlayers() {
  //Player(color normal, color right, color wrong, color show, color press)

  // "normal" is the normal color
  // "right" is the blinking with the last correct square of the sequence
  // "wrong" is when a wrong square is pressed
  // "show" is what the computer shows to the player
  // "press" is when the user presses a (correct) button mid-sequence
  //Player(color normal, color right, color wrong, color show, color press)

  players[0] = new Player(color(38, 204, 255), color(15, 82, 102), color(0, 0, 0), color(15, 82, 102), color(15, 82, 102));
  players[1] = new Player(color(255, 38, 128), color(102, 15, 51), color(0, 0, 0), color(102, 15, 51), color(102, 15, 51));
  players[2] = new Player(color(255, 255, 38), color(102, 102, 15), color(0, 0, 0), color(102, 102, 15), color(102, 102, 15));
  players[3] = new Player(color(110, 255, 38), color(44, 102, 15), color(0, 0, 0), color(44, 102, 15), color(44, 102, 15));

  players[0].active = true;
  players[1].active = false;
  players[2].active = false;
  players[3].active = false;

  validatePlayers();
}

void validatePlayers() {
  int countSoFar = 0;
  for (int i = 0; i < 4; i++) {
    if (countSoFar == playerCount)
      players[i].active = false;
    if (players[i].active)
      countSoFar++;
  }

  if (countSoFar < playerCount) {
    for (int i=0; i < 4;i++) {
      if ((!players[i].active) && countSoFar < playerCount) {
        players[i].active = true;
        countSoFar++;
      }
    }
  }
}

void initBoard() {
  calcGrid();
  ArrayList<Integer> g = new ArrayList<Integer>();

  int squaresPerPlayer = totalGridSz / playerCount;
  int i;
  for (i = 0; i < 4; i++)
    players[i].squares = squaresPerPlayer;

  for (int j=1; j <= 4; j++) {
    if (players[j-1].active)
      for (i=0;i < squaresPerPlayer;i++) {
        g.add(j);
      }
  }
  Collections.shuffle(g);

  int[] rectCount = new int[4];
  for (i = 0; i < 4; i++)
    rectCount[i] = 0;

  for (i=0; i < totalGridSz; i++) {
    int playr = g.get(i);
    rects[i] = new Rect(gridPoints[i], playr, defaultSize, rectCount[playr-1]);
    rectCount[playr-1]++;
  }
}

void createSequence(int player) {
  sequences[player] = new Sequence(3, players[player].squares);
  sequenceAnimations[player] = new SequenceAnimation(sequences[player], player+1);
  sequenceAnimations[player].enabled = players[player].active;
}


void initSequences() {
  for (int i = 0; i < 4; i++) {
    createSequence(i);
  }
}

Rect[] initRects = new Rect[4];
Button[] button = new Button[3];

void initMenu() {
  button[0] = new Button(new PVector(width/2-(rectSz+10), height/2), 2, 0.4, "2p.png");  
  button[1] = new Button(new PVector(button[0].x()+button[0].width(), height/2), 3, 0.4, "3p.png");
  button[2] = new Button(new PVector(button[1].x()+button[1].width(), height/2), 4, 0.4, "4p.png");

  int t = 10;
  int xOff = (width-height)/2;
  for (int i=0; i < 4;i++) 
    initRects[i] = new Rect(new PVector(), i+1, defaultSize*0.7, 0);
  initRects[0].pos.set(xOff+t, t, 0);
  initRects[1].pos.set(width-xOff-t-initRects[1].width(), t, 0);
  initRects[2].pos.set(xOff+t, height-t-initRects[2].height(), 0);
  initRects[3].pos.set(width-xOff-t - initRects[3].width(), height-t- initRects[3].height(), 0);
}

void restartGame() {
  // 45 seconds
  limitTime = millis + gameplayLength;
  setGameState(0);
  resetPlayers();
  validatePlayers();
  initBoard();
  initSequences();
}

void resetPlayers()
{
  for (int i=0; i<4; i++)
    players[i].reset();
}

void draw() {
  millis = millis();

  /*  if (limitTime == 0) {
   restartGame();
   }
   */
  if (gameState == -1) {
    background(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("DUPE", width/2, height/2);
    for (int i=0; i < 3;i++)
      button[i].draw();
  }
  else if (gameState== 0) {
    background(0);
    int ready=0;
    for (int i=0; i < 4;i++) {
      initRects[i].draw();
      if (players[i].ready)
        ready++;
    }
    if (ready==playerCount)
      setGameState(1);
  } 
  else if (gameState == 1 || gameState == 2) {

    background(0);

    int i;

    if (gameState == 1) {
      // backwards update because we might delete in-place
      for (i = sequenceAnimations.length-1; i >= 0; i--)
        sequenceAnimations[i].update();
    }
  
	pushMatrix();
	if (baseShape == 1) { // diamonds: rotate board 45 degrees
		translate(displayWidth/2, displayHeight/2);		
		scale(boardScale);
		rotate(-PI/4.0);
		translate(-displayWidth/2, -displayHeight/2);		
	}

    for (i=0;i < totalGridSz;i++) {
      rects[i].draw();
    }
    
    popMatrix();
    if (millis > limitTime)
      setGameState(2);
  }
  if (gameState == 2) { // endgame
    // for some time, fade to black
    float fraction = (millis - limitTime)/(float)fadeTime;
    fill(0, 0, 0, 255.0*fraction);
    rect(-100, -100, displayWidth + 200, displayHeight + 200);
    if (millis > limitTime + fadeTime)
      setGameState(3);
  }

  if (gameState == 3) {
    float fraction = (millis - limitTime - fadeTime)/(float)fadeTime;
    if (fraction > 1) fraction = 1;
    color winnerColor = players[winner].normal;
    fill(red(winnerColor), green(winnerColor), blue(winnerColor), 255*fraction);
    rect(-100, -100, displayWidth + 200, displayHeight + 200);
    // SHOW NUMBER?
  }
}

void mousePressed() {
  int i;
  PVector mouse = new PVector(mouseX, mouseY);
  if (gameState == -1) {
    for (i=0; i<3;i++)
      if (button[i].pressed(mouse)) {
        playerCount=i+2;
		restartGame();
        setGameState(1);
      }
  }
  else if (gameState == 0) {
    for (int j=0; j<4;j++)
      if (initRects[j].pressed(mouse))
        initRects[j].selectTime = millis;
  }
  // test: generate sequence
  //  int p = (int)random(2);
  //  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  

// test: generate sequence
//  int p = (int)random(2);
//  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  if (gameState == 1) {
    pushMatrix();
    if (baseShape == 1) { // diamonds: rotate board 45 degrees
		PVector offs = new PVector(displayWidth/2, displayHeight/2);
		mouse.sub(offs);		
		mouse.mult(1/boardScale);
		mouse.rotate(PI/4.0);
		mouse.add(offs);		
	}
    for (i=0;i < totalGridSz;i++) 
      if (rects[i].pressed(mouse)) {
        process(rects[i]);
        return;
      }
    popMatrix();
  } 
  else if (gameState == 3 && millis > limitTime + 2 * fadeTime) {
    setGameState(-1);
  }
}

void mouseReleased() {
  PVector mouse = new PVector(mouseX, mouseY);
  if (gameState == 0) {
    for (int i=0; i<4;i++)
      if (initRects[i].pressed(mouse))
        initRects[i].selectTime = -1;
  }
}

void process(Rect rect) {
  int pl = rect.player - 1;
  // play(rect.player,rect.id);
  //   println("S"+ player+"-"+note(tone)+".mp3");
  // println(rect.player+","+rect.id);
  if (sequenceAnimations[pl].playing())
    return;

  Sequence seq = sequences[pl];
  sequenceAnimations[pl].delayRepeat();
  if (seq.validKey(rect.id)) {
    rect.showTouched();
    if (seq.completed()) {
      //allRectsSuccess(rect.player);
      rect.showSuccess();
      players[pl].score++;
      createSequence(pl);
    }
  } 
  else {
    //rect.showFail();
    allRectsFail(rect.player);
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

void allRectsSuccess( int player ) {
  for (int i=0; i<rects.length; i++)
    if (rects[i].player == player)
      rects[i].showSuccess();
}

void allRectsFail( int player ) {
  for (int i=0; i<rects.length; i++)
    if (rects[i].player == player)
      rects[i].showFail();
}

void computeWinner() {
  winner = 0;
  int winnercount = -1;
  for (int i = 0; i < 4; i++)
    if (players[i].active && players[i].score >= winnercount) {
      winnercount = players[i].score;
      winner = i;
    }
}

void setGameState(int newState) {
  gameState = newState;

  if (newState == 2) {
    computeWinner();
  }
}

/*
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
*/

