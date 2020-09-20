class YouWon extends TextAnim {
  YouWon() {
    length = 120;
  }
  void draw(PGraphics g) {
    super.draw(g);
    g.text("You Won!", WIDTH / 2, HEIGHT / 2);
  }
}
