class GoldBar extends Thing {
  GoldBar(int x, int y) {
    super(x, y);
  }
  void draw(PGraphics g) {
    if (!isInBattle) {
      super.draw(g);
    }
  }
  void interact(Thing other) {
    if (other instanceof Movable) {
      ((Movable)other).performMove(location);
    }
    animations.add(new YouWon());
    win.play();
  }
  String getImage() {
    return "treasure";
  }
}
