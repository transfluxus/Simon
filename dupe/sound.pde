
/*
import apwidgets.*;

APMediaPlayer player;

void initSound() {
  player = new APMediaPlayer(this); //create new APMediaPlayer
  player.setMediaFile("S1-C.mp3"); //set the file (files are in data folder)
  player.start(); //start play back
    player.setMediaFile("S3-C.mp3"); //set the file (files are in data folder)
  player.start(); //start play back
//  player.setLooping(true); //restart playback end reached
//  player.setVolume(1.0, 1.0); //Set left and right volumes. Range is from 0.0 to 1.0
}

void play(String file) {
  player.setMediaFile(file); 
  player.start(); 
}

void play(int player, int tone) {
 play("S"+ player+"-"+note(tone)+".mp3");
} 

char note(int tone) {
 switch(tone) {
   case 0: return 'C';
   case 1: return 'D';
   case 2: return 'E';
   case 3: return 'F';
   case 4: return 'G';
   case 5: return 'H';   
   default: return 'C';
 } 
}

public void onDestroy() {
  super.onDestroy(); //call onDestroy on super class
  if(player!=null) { //must be checked because or else crash when return from landscape mode
    player.release(); //release the player

  }
}

*/
