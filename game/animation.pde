abstract class Animation {
  int length = 0;
  int frame = 0;
  void draw(PGraphics g) {
    if (frame >= length) {
      animations.remove(this);
    }
    frame++;
  }
}
