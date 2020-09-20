class Barrel extends Obstacle {
  Barrel(int x, int y) {
    super(x, y);
  }
  String getImage() {
    return "barrel";
  }
  void interact(Thing other) {
    other.seeObstacle(this);
  }
}
