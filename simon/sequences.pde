class Sequence {
  ArrayList<Integer> seq = new ArrayList<Integer>();
  int index;
  int score;
  boolean failed;

  Sequence( int len, int keycount ) {
	index = 0;
    score = 0;
	failed = false;
	for (int i = 0; i<len; i++)
		seq.add(int(random(keycount)));
  }

  int length() { return seq.size(); }

  // when user presses call this
  boolean validKey(int newKey) {
	index = index + 1;
	if (failed || index > seq.size())
		return false;

	boolean success = (newKey == seq.get(index-1));
	if (success) 
		score = index;
	else
		failed = true;
	return success;
  }

  // what is the user score
  int score() { return score; }

  // for showing it
  int getKey(int ndx) {
	return seq.get(ndx);
  }
}
