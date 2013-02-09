import java.util.Collections;

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
int playerCount = 2;

int gameState = 0;
// states: 0 - menu, 1 - game, 2 - end

void setup() {
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);


  initPlayers();
  
  initBoard();
  initMenu();
  initSequences();
  restartGame();
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
  players[1].active = true;
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
  rects =new Rect[totalGridSz];
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

    if (!players[player].active)
      sequenceAnimations[player].done = true;
}


void initSequences() {
  for (int i = 0; i < 4; i++) {
    createSequence(i);
  }
}

Rect[] initRects = new Rect[4];

void initMenu() {
  int t = 10;
  int xOff = (width-height)/2;
  for (int i=0; i < 4;i++) 
    initRects[i] = new Rect(new PVector(), i+1, defaultSize*1.4f, 0);
  initRects[0].pos.set(xOff+t, t, 0);
  println(t);
  initRects[1].pos.set(width-xOff-t-initRects[1].width(), t, 0);
  initRects[2].pos.set(xOff+t, height-t-initRects[2].height(), 0);
  initRects[3].pos.set(width-xOff-t- initRects[3].width(), height-t- initRects[3].height(), 0);
}

void restartGame() {

    // 45 seconds
    limitTime = millis + gameplayLength;
    setGameState(1);
    resetPlayers();
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
  if (gameState== 0) {
    background(0);
    for (int i=0; i < 4;i++) 
      initRects[i].draw();
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

  // test: generate sequence
  //  int p = (int)random(2);
  //  sequenceAnimations.add(new SequenceAnimation(new Sequence(5, playerKeyCount[p]), p+1));

  if (gameState == 1) {
    for (i=0;i < totalGridSz;i++) 
      if (rects[i].pressed(mouse)) {
        process(rects[i]);
        return;
      }
  } 
  else if (gameState == 3 && millis > limitTime + 2 * fadeTime) {
    restartGame();
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
