int w, h;

//int totalrectSz = 0.8f;
int gridW = 3, gridH=2, totalGridSz = gridW*gridH;
PVector[] gridPoints = new PVector[gridW*gridH];

int rectSz ;

void calcGrid() {
  rectSz = displayHeight / gridH;
  int xOff = (displayWidth - (rectSz*(gridW+1)));
  for (int x= 0; x < gridW; x++)
    for (int y=0; y <gridH; y++)
      gridPoints[x+y*gridW] = new PVector(xOff+x*rectSz+rectSz/2, y*rectSz+rectSz/2);
  rectSz=(int)(rectSz*0.7f);
}

