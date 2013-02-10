

class Button {

  PVector pos;
  int number;
  float size;
  PImage img;

  Button(PVector pos, int number, float size, String img) {
    this.pos = pos;
    this.number= number;
    this.size = size;
    this.img = loadImage(img);
  }

  float x() {
    return pos.x + rectSz*0.5*(1-size);
  }

  float y() {
    return pos.y + rectSz*0.5*(1-size);
  }
  float width() {
    return rectSz * size;
  }
  float height() {
    return rectSz * size;
  }

  void draw() {
    image(img, x(), y(), width(), height());
  }

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx && p.x <= tx+width() && p.y >=ty && p.y <= ty+height();
  }
}

