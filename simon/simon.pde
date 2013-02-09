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
  initSequences();
  strokeWeight(8);
  initSound();
}

void initPlayers() {
  //Player(color normal, color right, color wrong, color show, color press)
  //players[0] = new Player(color(255, 255, 38), color(255, 255, 204), color(255, 3, 3), color(255, 253, 179), color(102, 102, 15));
  //players[1] = new Player(color(255, 38, 128), color(255, 204, 225), color(255, 3, 3), color(255, 89, 158), color(102, 15, 51));
  //players[2] = new Player(color(38, 204, 255), color(204, 243, 255), color(255, 3, 3), color(89, 216, 255), color(15, 82, 102));
  //players[3] = new Player(color(110, 255, 38), color(221, 255, 204), color(255, 3, 3), color(144, 255, 89), color(44, 102, 15));
  
  
  //players[0] = new Player(color(255, 255, 38), color(255, 253, 179), color(102, 102, 15), color(255, 253, 179), color(255, 253, 179));
  //layers[1] = new Player(color(255, 38, 128), color(255, 179, 210), color(102, 15, 51), color(255, 179, 210), color(255, 179, 210));
 //players[2] = new Player(color(38, 204, 255), color(128, 225, 255), color(15, 82, 102), color(128, 225, 255), color(128, 225, 255));
 // players[3] = new Player(color(110, 255, 38), color(204, 255, 179), color(44, 102, 15), color(204, 255, 179), color(204, 255, 179));
  
  players[0] = new Player(color(38, 204, 255), color(128, 225, 255), color(0, 0, 0), color(128, 225, 255), color(128, 225, 255));
  players[1] = new Player(color(255, 38, 128), color(255, 179, 210), color(0, 0, 0), color(255, 179, 210), color(255, 179, 210));
  players[2] = new Player(color(255, 255, 38), color(255, 253, 179), color(0, 0, 0), color(255, 253, 179), color(255, 253, 179));
  players[3] = new Player(color(110, 255, 38), color(204, 255, 179), color(0, 0, 0), color(204, 255, 179), color(204, 255, 179));
  
  
  players[0].active = true;
  players[1].active = true;

}

void initBoard() {
  rects =new Rect[totalGridSz];
  calcGrid();
  boolean[] playerG = new boolean[totalGridSz];
  ArrayList<Integer> g = new ArrayList<Integer>();

  players[0].squares = int(totalGridSz/2);
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
    rects[i] = new Rect(gridPoints[i], playr, defaultSize, rectCount[playr-1]);
    rectCount[playr-1]++;
  }
}

void createSequence(int player) {
    sequences[player] = new Sequence(4, players[player].squares);
    sequenceAnimations[player] = new SequenceAnimation(sequences[player], player+1);

    if (player>1)
      sequenceAnimations[player].done = true;
}


void initSequences() {
  for (int i = 0; i < 4; i++) {
      createSequence(i);
  }
}

void restartGame() {
    // 45 seconds
    limitTime = millis + gameplayLength;
    setGameState(1);
    resetPlayers();
}

void resetPlayers()
{
  for (int i=0; i<4; i++)
    players[i].reset();
}

void draw() {
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
    fill(0,0,0, 255.0*fraction);
    rect(-100, -100, displayWidth + 200, displayHeight + 200);
    if (millis > limitTime + fadeTime)
      setGameState(3);
  }
  
  if (gameState == 3) {
     float fraction = (millis - limitTime - fadeTime)/(float)fadeTime;
     if (fraction > 1) fraction = 1;
     color winnerColor = players[winner].normal;
     fill(red(winnerColor),green(winnerColor),blue(winnerColor), 255*fraction);
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
  } else if (gameState == 3 && millis > limitTime + 2 * fadeTime) {
      restartGame();
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
         //allRectsSuccess(rect.player);
         rect.showSuccess();
         players[pl].score++;
         createSequence(pl);
       }
  } else {
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
  int winnercount = players[0].score;
  for (int i = 1; i < playerCount; i++)
      if (players[i].score >= winnercount) {
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
