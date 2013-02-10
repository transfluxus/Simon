int w, h;

int gridW, gridH, totalGridSz;
PVector[] gridPoints;
int baseShape;
// baseShape: 0- rect, 1- diamond

float boardScale;
int rectSz ;

void calcGrid() {
	calcStandardGrid();
}

// square grid
void calcStandardGrid() {
  gridW = 4; 
  gridH = 3;
  totalGridSz = gridW*gridH;
  gridPoints = new PVector[gridW*gridH];
  baseShape = 0;
  boardScale = 1.0;
  rects = new Rect[totalGridSz];
  rectSz = displayHeight / gridH;
  int xoff = (int)(displayWidth * 0.5 - gridW * rectSz * 0.5);
  for(int x= 0; x < gridW; x++) {
    for(int y=0; y <gridH; y++) {
      gridPoints[x+y*gridW] = new PVector(xoff + x*rectSz,y*rectSz);
    }
  }
}

// diamond grid
void calcDiamondGrid() {
  int [] [] cells = new int[] [] {
      { 0, 1, 0, 0, 0 },
      { 1, 1, 1, 1, 0 },
      { 0, 1, 0, 1, 0 },
      { 0, 1, 1, 1, 1 },
      { 0, 0, 0, 1, 0 }
    } ;
  gridW = 5;
  gridH = 5;
  totalGridSz = 12;
  gridPoints = new PVector[totalGridSz];
  baseShape = 1;
  boardScale = 5.0/(3.0*sqrt(2.0));
  rects = new Rect[totalGridSz];
  gridPoints = new PVector[gridW*gridH];
  rectSz = displayHeight / gridH;
  int xoff = (int)(displayWidth * 0.5 - gridW * rectSz * 0.5);
  int i = 0;
  for(int x= 0; x < gridW; x++) {
    for(int y=0; y < gridH; y++) {
      if (cells[x][y] == 1) {
      	gridPoints[i] = new PVector(xoff + x*rectSz,y*rectSz);
		i++;
	  }
    }
  } 
}

void calcLsGrid() {
	int [] [] cells = new int[] [] {
      { 1, 1, 0, 0, 0, 1, 1 },
      { 1, 0, 0, 0, 0, 0, 1 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 1, 0, 0, 0, 0, 0, 1 },
	  { 1, 1, 0, 0, 0, 1, 1 }
    } ;
  gridW = 7;
  gridH = 5;
  totalGridSz = 18;
  gridPoints = new PVector[totalGridSz];
  baseShape = 0;
  boardScale = 1.0;
  rects = new Rect[totalGridSz];
  gridPoints = new PVector[gridW*gridH];
  rectSz = displayHeight / gridH;
  int xoff = (int)(displayWidth * 0.5 - gridW * rectSz * 0.5);
  int i = 0;
  for(int x= 0; x < gridW; x++) {
    for(int y=0; y < gridH; y++) {
      if (cells[y][x] == 1) {
      	gridPoints[i] = new PVector(xoff + x*rectSz,y*rectSz);
		i++;
	  }
    }
  }

  int yoff = (int)displayHeight/2 - rectSz;
  xoff = (int)displayWidth/2 - rectSz * 3/2;
  for(int x= 0; x < 3; x++) {
    for(int y=0; y < 2; y++) {
      	gridPoints[i] = new PVector(xoff + x*rectSz,yoff + y*rectSz);
		i++;
	  }
    }

}
