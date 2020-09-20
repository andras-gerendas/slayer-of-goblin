class BeginBattle extends TextAnim {
  BeginBattle() {
    length = 45;
  }
  void draw(PGraphics g) {
    super.draw(g);
    g.text("Battle Begins!", WIDTH / 2, HEIGHT / 2);
  }
}
