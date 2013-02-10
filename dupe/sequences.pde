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

int sequenceStepTime = 500;
int sequenceStartTime = 1200;
int repeatDelay = 3000;

class SequenceAnimation {
  Sequence seq;
  int owner;
  int index;
  int switchTime;
  int timer;
  int repeatTime;
  boolean done;
  boolean enabled;
  SequenceAnimation( Sequence seq, int player ) {
      this.seq = seq;
      this.owner = player;
      this.enabled = true;
      restart();
      this.switchTime = millis + sequenceStartTime;
  }

  void restart() {
      this.index = 0;
      this.switchTime = millis;
      this.done = false;
	  delayRepeat();
  }

  void delayRepeat() {
    repeatTime = millis + repeatDelay;
  }
  
  // returns true when anim finished
  boolean update() {
    if (!enabled) return false;
    if (done) {
		if (millis >= repeatTime) {
			restart(); 
			done = false;
		}
	} else {
		 boolean blink = false;
		 
		 if (millis >= switchTime) {
			blink = true;
			switchTime += sequenceStepTime;
		}

		if (blink) {
		    int rectI = seq.getKey(index);
		    rects[rectIndex(owner, rectI)].showShow();
			index++;
			if (index == seq.length()) {
				delayRepeat();
				done = true;
			}
		}
	}
	return done;
  }
  
  boolean playing() { return !done; }

}
