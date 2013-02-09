int blinkTime=300;
float defaultSize = 0.8f;

class Rect {

  PVector pos;
  int player; 
  color clr;
  boolean blink;
  int blinkStartTime;
  float size;

  int id;

  Rect(PVector pos, int player, color clr, float size, int id) {

    this.pos = pos;
    this.player= player;
    this.clr = clr;
    this.size = size;
    this.id = id;
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

  void draw() {
    stroke(clr);
    if (blink)
      fill(clr);
    else noFill();

    int t = blinkTime - (millis-blinkStartTime);
      if (t<0) {
        blink=false;
        size=defaultSize;
      }
      else
      size = defaultSize+(1-defaultSize)*sin(map(blinkTime-t,0,blinkTime,0,PI));
    //    size = 0.8f* sin(t/blinkTime * 
    rect(x(), y(), width(), height(), 10);
  }

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }



  void blink() {
    blink=true;
    blinkStartTime = millis;
  }
}
