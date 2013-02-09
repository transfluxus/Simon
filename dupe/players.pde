class Player {
  color normal;
  color right;
  color wrong;
  color show;
  color press;
  
  boolean active;
  int score;
  int squares;
  
  
  Player(color normal, color right, color wrong, color show, color press)
  {
    this.normal = normal;
    this.right = right;
    this.wrong = wrong;
    this.show = show;
    this.press = press;
    reset();
  }
  
  void reset() {
    //active = false;
    score = 0;
    //squares = 0;
  }
  
  void inc() {
    score++;
  }

}
