import android.media.SoundPool; //this is the audio player for short quick audio files
import android.content.res.AssetManager; //the asset manager helps us find specific files and can be used in the style of an array if needed
import android.media.AudioManager; //the audio manager controlls all the audio connected to it, enabeling overall volume and such
import android.media.MediaPlayer;
import android.content.res.AssetFileDescriptor;

SoundPool soundPool;
AssetManager assetManager;
MediaPlayer mediaPlayer;

int nSounds = 8;
int soundIds[] = new int[nSounds];
boolean[] soundOn= new boolean[nSounds];
int[] soundTimer= new int[nSounds];
String[] soundsF = { 
  "p1w", "p1l", "p2w", "p2l", "p3w", "p3l", "p4w", "p4l"
};

int song;

float fxVolume=1f, musicVolume=0.4f;


void initSounds() {
  soundPool = new SoundPool(20, AudioManager.STREAM_MUSIC, 0); //(max #of streams, stream type, source quality) - see the android reference for details
  mediaPlayer = new MediaPlayer();
  assetManager = this.getAssets();

  try { 
    mediaPlayer.reset();
    AssetFileDescriptor  afd = this.getAssets().openFd("samples/dupe-main.mp3");
    mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
    afd.close();
    mediaPlayer.prepare();
    //    println(song);
    for (int i=0; i<nSounds;i++) 
      soundIds[i] = soundPool.load(assetManager.openFd("samples/"+soundsF[i]+".wav"), 0); //load the files
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

void playMain() {
//  mediaPlayer.stop();
  mediaPlayer.start();
  mediaPlayer.setVolume(musicVolume, musicVolume);
}

void playSuccess(int player) {
  int i= player*2;
  soundPool.play(soundIds[i], fxVolume, fxVolume, 0, 0, 1); 
  soundTimer[i] = millis;
}

void playFail(int player) {
  int i= player*2+1;
  soundPool.play(soundIds[i], fxVolume, fxVolume, 0, 0, 1); 
  soundTimer[i] = millis;
}

void updateSounds() {
  for (int i=0; i < nSounds;i++) {
    if (soundOn[i])
      if (millis-soundTimer[i]<1000) {
        float f = 1-(millis-soundTimer[i])/1000f;
        soundPool.setVolume(soundIds[i], f, f);
      }  
      else
        soundOn[i] =false;
  }
}

