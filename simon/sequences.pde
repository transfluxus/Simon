class Sequence {
  ArrayList<Integer> seq = new ArrayList<Integer>();
  int index;
  boolean failed;

  Sequence( int len, int keycount ) {
	index = 0;
	failed = false;
	for (int i = 0; i<len; i++)
		seq.add(int(random(keycount)));
  }

  int length() { return seq.size(); }

  // when user presses call this
  boolean validKey(int newKey) {
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
  int score() { return index; }
  
  // if the sequence was successfully completed
  boolean completed() { return (index == length()) && !failed; }

  // for showing it
  int getKey(int ndx) {
	return seq.get(ndx);
  }
}

int sequenceStepTime = 1000;
class SequenceAnimation {
  Sequence seq;
  int owner;
  int index;
  int startTime;
  int timer;
  boolean done;
  SequenceAnimation( Sequence seq, int player ) {
      this.seq = seq;
      this.owner = player;
      this.index = 0;
      this.startTime = millis;
      this.timer = -1;
      this.done = false;
  }
  
  // returns true when anim finished
  boolean update() {
	 if (done) return true;
     boolean blink = false;
     if (timer == -1) {
        //blink = true;
        startTime = millis;
        timer = 0;
     }
     
     int dt = millis - startTime;
     startTime = millis;
     timer = timer + dt;
     if (timer >= sequenceStepTime) {
		blink = true;
		timer -= sequenceStepTime;
	}

	if (blink) {
		int rectI = seq.getKey(index);
                rects[rectIndex(owner, rectI)].showTouched();
		index++;
		if (index == seq.length())
			done = true;
	}
	return done;
  }
  
  boolean playing() { return !done; }

}
