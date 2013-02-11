import java.util.Collections;

/*
import ketai.ui.*;
KetaiGesture gesture;
*/

Rect[] rects;
Sequence[] sequences = new Sequence[4];
SequenceAnimation[] sequenceAnimations = new SequenceAnimation[4];

int millis;

Player [] players = new Player[4];

int limitTime = 0;
int fadeTime = 1000;
int waitTime = 2000;
int startTime = 0;
boolean started = false;
int gameplayLength = 45000; //45000;
int winner = 0;
int playerCount = 4;

int menuScreen = 0;
// menuScreen: 0 - select player, 1 - select color, 2 - instructions, 3 - credits

int gameState = -1;
// states: -1 - intro screen, 0 - color select/check ready, 1 - game, 2 - end
int ready=0;
PImage titleImage, tapColor, win, instructions, creditsTitle, creditsNames;
Animation howtoAnim;

void setup() {
  //size(600,400);
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);

  // gesture = new KetaiGesture(this);

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

void assignColors() {
   for (int i=0; i<4; i++)
     players[i].active = initRects[i].selected;
}

void resetColorSelection() {
     ready = 0;
     for (int i=0; i<4; i++)
       initRects[i].selected = false;

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
Button[] button = new Button[6];

void initMenu() {
  button[0] = new Button(new PVector(width/2 - min(width/4,height/4) , height * 0.6f), 2, 0.5f, "2p.png");  
  button[1] = new Button(new PVector(width/2, height * 0.6f), 3, 0.5f, "3p.png");
  button[2] = new Button(new PVector(width/2 + min(width/4, height/4), height * 0.6f), 4, 0.5f, "4p.png");
  button[3] = new Button(new PVector(width*13/16f, height * 15/16f), 5, 0.3f, "howto.png");
  button[4] = new Button(new PVector(width*2/16f, height * 15/16f), 6, 0.3f, "credits.png");
  button[5] = new Button(new PVector(width/2, height * 14/16f), 7, 1f, "back.png");

  titleImage = loadImage("dupeTitle.png");
  tapColor = loadImage("tap_your_colour.png");
  win = loadImage("win.png");
  instructions = loadImage("instruction_words.png");
  creditsTitle = loadImage("credits_title.png");
  creditsNames = loadImage("credits_names.png");

  rectSz = (height-60)/2;
  for (int i=0; i < 4;i++) 
    initRects[i] = new Rect(new PVector(), i+1, 1.0, 0);

  int xOff = 2*width/3 - rectSz - 10;
  int yOff = 20;
  int xOff2 = xOff + 20 + rectSz;
  int yOff2 = yOff + 20 + rectSz;
  initRects[0].pos.set(xOff, yOff, 0);
  initRects[1].pos.set(xOff2, yOff, 0);
  initRects[2].pos.set(xOff, yOff2, 0);
  initRects[3].pos.set(xOff2, yOff2, 0);

  // animation
  howtoAnim = new Animation(width/2, height * 0.6, height / 1600f, 500);
  for (int k=0; k<8; k++) {
	String pre_zero = "0";
	if (k>9) pre_zero = "";
	howtoAnim.addFrame("animation/frame"+pre_zero+k+".png");
  }
}

void restartGame() {
  // 45 seconds
  limitTime = millis + gameplayLength + waitTime;
  startTime = millis + waitTime;
  setGameState(1);
  resetPlayers();
  validatePlayers();
  initBoard();
  initSequences();
  started = false;
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
    showMenuScreen();
  }
  else if (gameState== 0) {
    background(0);
    imageMode(CORNER);
    int wi = tapColor.width;
    int hi= tapColor.height;
    float scale = min( (height/2f) / tapColor.height, (width/3f) / (tapColor.width+ 50) );
    image(tapColor, 30, height/2, scale*wi, scale*hi);
    rectSz = (height-60)/2;
    for (int i=0; i < 4;i++) 
      initRects[i].draw();
    //        println("ready "+ready + " / wait for "+playerCount);
    if (ready==playerCount) {
      assignColors();
      restartGame();
    }
  } 
  else if (gameState == 1 || gameState == 2) {

    background(0);

    int i;

    if (gameState == 1) {
	  if (started) {
		  for (i = 0; i < sequenceAnimations.length; i++)
		    sequenceAnimations[i].update();
		} else if (millis >= startTime) {
			allRectsBlink();
			initSequences();
			started = true;		
		}
    }

    pushMatrix();
    if (baseShape == 1) { // diamonds: rotate board 45 degrees
      translate(width/2, height/2);		
      scale(boardScale);
      rotate(-PI/4.0);
      translate(-width/2, -height/2);
    }

    for (i=0;i < totalGridSz;i++) {
      rects[i].draw();
    }

    popMatrix();

	// overlay at start
	if (!started) {
		float fraction = min(1.0, (startTime - waitTime/2 - millis) / float(waitTime/2));
		if (fraction > 0) {
			fill(0,0,0, 255*fraction);
		    rect(-100, -100, width + 200, height + 200);
		}
	}


    if (millis > limitTime)
      setGameState(2);
  }
  if (gameState == 2) { // endgame
    // for some time, fade to black
    float fraction = (millis - limitTime)/(float)fadeTime;
    fill(0, 0, 0, 255.0*fraction);
    rect(-100, -100, width + 200, height + 200);
    if (millis > limitTime + fadeTime)
      setGameState(3);
  }

   if (gameState == 3) {
    float fraction = (millis - limitTime - fadeTime)/(float)fadeTime;
    if (fraction > 1) fraction = 1;
    color winnerColor = players[winner].normal;
    fill(red(winnerColor), green(winnerColor), blue(winnerColor), 255);
    rect(-100, -100, width + 200, height + 200);
    // SHOW NUMBER?
    int wi = win.width;
    int hi= win.height;
    float scale = (height/3.5f)/ win.height;
    imageMode(CENTER);
    image(win,width/2,height/2,wi*scale,hi*scale);
    
    fill(0,0,0, 255*(1-fraction));
    rect(-100, -100, width + 200, height + 200);
  }
}

void showMenuScreen() {
	switch (menuScreen) {
		case 0 : { // main menu
			imageMode(CENTER);
			int wi = titleImage.width;
			int hi= titleImage.height;
			float scale = (height/3f) / titleImage.height ;

			image(titleImage, width/2, height/2 - titleImage.height*scale * 5 / 8, scale*wi, scale*hi);

			for (int i=0; i < 5;i++)
			  button[i].draw();
		break;
		}
		case 2 : {  // instructions
			imageMode(CENTER);
			float scale = height / 850f;
			image(instructions, width/2, height/2 - instructions.height*scale, scale*instructions.width, scale*instructions.height);
			howtoAnim.draw();
			button[5].draw();
		break;
		}
		case 3: { // credits
			imageMode(CENTER);
			float scale = height / 850f;
			image(creditsTitle, width/2, height*1/8, creditsTitle.width * scale, creditsTitle.height * scale);
			image(creditsNames, width/2, height/2, scale*creditsNames.width, scale*creditsNames.height);
			button[5].draw();
		break;
		}
	}
}

void mousePressed() {
  managePressed(mouseX, mouseY);
}

void managePressed(int mX, int mY) {
  int i;
  PVector mouse = new PVector(mX, mY);
  if (gameState == -1) {
	if (menuScreen == 0) {
		for (i=0; i<3;i++)
		  if (button[i].pressed(mouse)) {
		    playerCount=i+2;
		    gameState=0;
		  }
		if (button[3].pressed(mouse)) {
			menuScreen = 2;
			howtoAnim.restart();
		}
		if (button[4].pressed(mouse)) {
			menuScreen = 3;
		}
	} else if (menuScreen == 2 || menuScreen == 3) {
		if (button[5].pressed(mouse)) {
			menuScreen = 0;
		}
	}
  }
  else if (gameState == 0) {
    for (int j=0; j<4;j++)
      if (initRects[j].pressed(mouse)) {
        initRects[j].selected = !initRects[j].selected;
        if (initRects[j].selected)
          ready++;
        else ready--;
      }
  }

  if (gameState == 1) {

    if (baseShape == 1) { // diamonds: rotate board 45 degrees
		PVector offs = new PVector(width/2, height/2);
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
  } 
  else if (gameState == 3 && millis > limitTime + 2 * fadeTime) {
    setGameState(-1);
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

void allRectsBlink() {
	for (int i=0; i<rects.length; i++)
      rects[i].showSuccess();
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
  
  if (newState == -1) {
    resetColorSelection();
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

