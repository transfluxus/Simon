
/*
public boolean surfaceTouchEvent(android.view.MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}

void onTap(float x, float y)
{
  int i;
  PVector mouse = new PVector(x, y);
  if (gameState == -1) {
    for (i=0; i<3;i++)
      if (button[i].pressed(mouse)) {
        playerCount=i+2;
        gameState=0;
        println(i);
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

  if (baseShape == 1) { // diamonds: rotate board 45 degrees
    PVector offs = new PVector(displayWidth/2, displayHeight/2);
    mouse.sub(offs);    
    mouse.mult(1/boardScale);
    mouse.rotate(PI/4.0);
    mouse.add(offs);    
  }

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
*/
