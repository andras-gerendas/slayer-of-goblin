class BattleWon extends TextAnim {
  BattleWon() {
    length = 58;
  }
  void draw(PGraphics g) {
    super.draw(g);
    g.text("Battle Won!", WIDTH / 2, HEIGHT / 2);
  }
}
