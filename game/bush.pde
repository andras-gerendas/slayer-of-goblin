class Bush extends Obstacle {
  Bush(int x, int y) {
    super(x, y);
  }
  String getImage() {
    return "bush";
  }
  void interact(Thing other) {
    other.seeObstacle(this);
  }
}
