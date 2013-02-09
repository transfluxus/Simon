import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;

void initSound() {
  minim = new Minim(this);
  play("C.wav");
   play("C.wav");
}

void play(String file) {
  player = minim.loadFile(file);
  player.play();
}

