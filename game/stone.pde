class Stone extends Obstacle {
  Stone(int x, int y) {
    super(x, y);
  }
  String getImage() {
    return "stone";
  }
  void interact(Thing other) {
    other.seeObstacle(this);
  }
}
