abstract class TextAnim extends Animation {
  void draw(PGraphics g) {
    super.draw(g);
    g.textFont(font);
    g.textAlign(CENTER);
    g.textSize(30);
    if (frame % 4 < 2) {
      g.fill(0);
      g.stroke(0);
    } else {
      g.fill(#FF0000);
      g.stroke(#FF0000);
    }
  }
}
