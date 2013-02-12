

public boolean surfaceTouchEvent(android.view.MotionEvent me) {

  int action = (me.getAction() & me.ACTION_MASK);

  if (action == me.ACTION_DOWN || action == me.ACTION_POINTER_DOWN) {

    final int pointerIndex = (me.getAction() & me.ACTION_POINTER_INDEX_MASK) 
      >> me.ACTION_POINTER_INDEX_SHIFT;
    final int pointerId = me.getPointerId(pointerIndex);
   
    managePressed((int)me.getX(pointerId),(int)me.getY(pointerId));
  }
  return super.surfaceTouchEvent(me);
}

