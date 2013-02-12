class Animation {
    int currentFrame;
	int frameDelay;
	int timer;
	float scale;
	PVector pos;
	ArrayList<PImage> frames = new ArrayList<PImage>();
	ArrayList<Integer> delays = new ArrayList<Integer>();

	Animation(float x, float y, float scale, int delay) {
		timer = 0;
		currentFrame = 0;
		frameDelay = delay;
		pos = new PVector(x,y);
		this.scale = scale;
	}

	void setPosition(float x, float y) {
		pos = new PVector(x,y);
	}


	void addFrame(String filename) {
		addFrame(filename, frameDelay);
	}

	void addFrame(String filename, int delay) {
		frames.add(loadImage(filename));
		delays.add(delay);
	}


	void restart() {
		currentFrame = 0;
		if (delays.size() > 0)
			timer = millis + delays.get(0);
	}

	void draw() {
		if (frames.size() > 0) {
			if (millis >= timer) {
				currentFrame = (currentFrame + 1) % frames.size();				
				timer = millis + delays.get(currentFrame);
			}

			PImage f = frames.get(currentFrame);
			image(f, pos.x, pos.y, f.width * scale, f.height * scale);
		}
	}
}
