int blinkTime=300;
float defaultSize = 0.97f;
int selectTimeT = 1000;

class Rect {

  PVector pos;
  int player; 
  color clr;
  int time;
  float size;

  int state;
  // 0: normal, 1: pressed, 2: show, 3: success, 4: fail

  int id;

  int selectTime = -1;

  Rect(PVector pos, int player, float size, int id) {
    this.pos = pos;
    this.player= player;
    this.size = size;
    this.id = id;
    this.state = 0;
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

  void resetColors() {
    this.state = 0;
    this.time = 0;
  }

  void updateColors() {
    if (millis > time)
      state = 0;

    if (state == 0)
      clr = players[player-1].normal;
    if (state == 1)
      clr = players[player-1].press;
    if (state == 2)
      clr = players[player-1].show;
    if (state == 3) {
      boolean blinkState = ((millis - time + 2*blinkTime) % (blinkTime/2)) < blinkTime/4;
      if (blinkState)
        clr = players[player-1].right;
      else
        clr = players[player-1].normal;
    }
    if (state == 4)
      clr = players[player-1].wrong;
  }

  void draw() {
    if (gameState==0)
      clr = players[player-1].press;
    else
      updateColors();
    fill(clr);
    noStroke();
    rect(x(), y(), width(), height());
    if (gameState==0) {
      showSelect();
    }
  }

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }

  void resetTimer() {
    this.time = millis + blinkTime;
  }

  void showTouched() {
    state = 1;
    resetTimer();
  }

  void showSuccess() {
    state = 3;
    resetTimer();
    time = time + blinkTime;
  }

  void showFail() {
    state = 4;
    resetTimer();
  }

  void showShow() {
    state = 2;
    resetTimer();
  }

  void showSelect() {
    if (selectTime>=0) {
      float      s = map(millis-selectTime, 0, selectTimeT, 0, width());
      s = min(s, width() );
      rectMode(CENTER);
      noStroke();
      fill(players[player-1].normal);
      rect(x()+width() / 2, y()+ height()/2, s, s );
      rectMode(CORNER);
      selectTime++;
      players[player-1].ready = ( millis-selectTime >selectTimeT);
    }
  }
}

