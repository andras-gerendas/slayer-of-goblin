class BattleLost extends TextAnim {
  BattleLost() {
    length = 58;
  }
  void draw(PGraphics g) {
    super.draw(g);
    if (isInBattle) {
      g.text("Battle Lost!", WIDTH / 2, HEIGHT / 2);
    }
  }
}
