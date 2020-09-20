class GameStart extends TextAnim {
  GameStart() {
    length = 58;
  }
  void draw(PGraphics g) {
    super.draw(g);
    g.text("Slayer of Goblin", WIDTH / 2, HEIGHT / 2);
  }
}
