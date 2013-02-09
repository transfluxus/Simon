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
  boolean completed() { return (index == length() - 1) && !failed; }

  // for showing it
  int getKey(int ndx) {
	return seq.get(ndx);
  }
}
