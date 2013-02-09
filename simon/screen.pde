int w, h;

//int totalrectSz = 0.8f;
int gridW = 3, gridH = 2, totalGridSz = gridW*gridH;
PVector[] gridPoints = new PVector[gridW*gridH];

int rectSz ;
int xoff;

void calcGrid() {
  rectSz = displayHeight / gridH;
  xoff = (int)(displayWidth * 0.5 - gridW * rectSz * 0.5);
  for(int x= 0; x < gridW; x++) {
    for(int y=0; y <gridH; y++) {
      gridPoints[x+y*gridW] = new PVector(xoff + x*rectSz,y*rectSz);
    }
  }
}


