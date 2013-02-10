

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
    return pos.x + img.width*0.5*(1-size);
  }

  float y() {
    return pos.y + img.height*0.5*(1-size);
  }
  float width() {
    return img.width * size;
  }
  float height() {
    return img.height * size;
  }

  void draw() {
    image(img, x(), y(), width(), height());
  }

  boolean pressed(PVector p) {
    float tx = x();
    float ty = y();
    return p.x >=tx-width()/2 && p.x <= tx+width()/2 && p.y >=ty-height/2 && p.y <= ty+height()/2;
  }
}

