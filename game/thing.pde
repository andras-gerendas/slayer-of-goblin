abstract class Thing implements IDrawable, ILoadable {
  public Point location = new Point();
  public PImage image;
  public PImage up;
  public PImage down;
  public PImage battle;
  public PImage battleUp;
  public PImage battleDown;
  public GraphNode node;
  Thing() {    
  }
  Thing(int x, int y) {
    location.x = x;
    location.y = y;
  }
  void draw(PGraphics g) {
    if (image != null) {
      g.image(image, location.x * SIZE, location.y * SIZE);
    } else {
      g.rect(location.x * SIZE, location.y * SIZE, SIZE, SIZE);
    }
  }
  void load() {
    image = loadImage(getImage() + ".png");
    if (getUp() != null) {
      up = loadImage(getUp() + ".png");
    }
    if (getDown() != null) {
      down = loadImage(getDown() + ".png");
    }
    if (getBattle() != null) {
      battle = loadImage(getBattle() + ".png");
    }
    if (getBattleUp() != null) {
      battleUp = loadImage(getBattleUp() + ".png");
    }
    if (getBattleDown() != null) {
      battleDown = loadImage(getBattleDown() + ".png");
    }
  }
  boolean isAtPoint(Point point) {
    return point.x == location.x && point.y == location.y;
  }
  void setLocation(Point point) {
    this.location = point;
  }
  void interact(Thing other) {
  }
  void seeObstacle(Thing other) {
  }
  int getX() {
    return location.x;
  }
  int getY() {
    return location.y;
  }
  Point getLocation() {
    return location;
  }
  String getUp() {
    return null;
  }
  String getDown() {
    return null;
  }
  String getBattle() {
    return null;
  }
  String getBattleUp() {
    return null;
  }
  String getBattleDown() {
    return null;
  }
  void suffer(int damage) {
  }
  int getID() {
    return node.id();
  }
  GraphNode[] getRoute(Point target) {
      IGraphSearch pathFinder = new GraphSearch_Astar(graph);
      pathFinder.search(location.y * (WIDTH / SIZE) + location.x, target.y * (WIDTH / SIZE) + target.x);
      GraphNode[] route = pathFinder.getRoute();
      return route;
  }
}
