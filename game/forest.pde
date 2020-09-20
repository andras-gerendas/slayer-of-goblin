class Forest extends Obstacle {
  Forest(int x, int y) {
    super(x, y);
  }
  String getImage() {
    int rand = int(random(3));
    if (rand == 0) {
      return "forest";
    } else if (rand == 1){
      return "forest2";
    } else {
      return "forest4";
    }
  }
}
