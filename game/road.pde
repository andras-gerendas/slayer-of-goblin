class Road extends Thing {
  Road(int x, int y) {
    super(x, y);
  }
  void interact(Thing other) {
    if (other instanceof Movable) {
      ((Movable)other).performMove(location);
    }
  }
  String getImage() {
    return "road";
  }
}
