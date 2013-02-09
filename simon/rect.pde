int blinkTime=300;
float defaultSize = 0.97f;

class Rect {

  PVector pos;
  int player; 
  color baseColor;
  color clr;
  color borderClr;
  boolean touched;
  boolean success;
  boolean fail;
//  int blinkStartTime;
  int time;
  float size;

  int id;

  Rect(PVector pos, int player, color clr, float size, int id) {

    this.pos = pos;
    this.player= player;
    this.baseColor = clr;
    this.clr = clr;
    this.borderClr = clr;
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
  
  void resetColors() {
    this.touched = false;
    this.success = false;
    this.fail = false;
    this.time = 0;
  }
  
  void updateColors() {
    int currentTime = millis;
    float baseShade = 0.7;
    if (currentTime <= time) {
      if (fail) {
        //clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
        clr = color(255, 3, 3);
      } else if (success) {
        //clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
        clr = color(199, 249, 102); //color(3,255,3);
      } else if (touched) {
        float timeFraction = (time-currentTime)/(float)blinkTime;
        float colorFraction = baseShade + (1-baseShade) * pow(timeFraction,0.1);
        clr = color(red(baseColor) * colorFraction, green(baseColor) * colorFraction, blue(baseColor) * colorFraction);
        borderClr = clr;
      }
    } else {
      resetColors();
      clr = color(red(baseColor) * baseShade, green(baseColor) * baseShade, blue(baseColor) * baseShade);
      borderClr = clr;
    }

  
  }

  void draw() {
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

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }

  void resetTimer() {
    this.time = millis + blinkTime;
  }

  void showTouched() {
    touched = true;
    resetTimer();
  }
  
  void showSuccess() {
    success = true;
    resetTimer();
  }
  
  void showFail() {
    fail = true;
    resetTimer();
  }
}
