class Point {
  private int x;
  private int y;
  Point() {
    x = 0;
    y = 0;
  }
  Point(int x, int y) {
    setX(x);
    setY(y);
  }
  void setX(int x) {
    if (x < 0) {
      x = 0;
    }
    this.x = x;
  }
  void setY(int y) {
    if (y < 0) {
      y = 0;
    }
    this.y = y;
  }
  void translate() {
    x = x / SIZE;
    y = y / SIZE;
  }
  public Object clone() {  
    return new Point(x, y);
  }  
};
