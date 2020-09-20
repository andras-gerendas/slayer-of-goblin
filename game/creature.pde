abstract class Creature extends Movable {
  int maxHP = 0;
  int hp = 0;
  int range = 0;
  boolean isRanged = true;
  boolean isDead = false;
  int meleeDamage = 0;
  Creature(int x, int y) {
    super(x, y);
  }
  void draw(PGraphics g) {
    super.draw(g);
    if (isInBattle) {
      if (maxHP > 0) {
        int barSize = (int)(hp / (float)maxHP * SIZE);
        g.noStroke();
        g.fill(#FF0000);
        g.rect(location.x * SIZE, location.y * SIZE - 5, barSize, 3);
        g.fill(0);
        g.rect(location.x * SIZE + barSize, location.y * SIZE - 5, SIZE - barSize, 3);
        g.stroke(255);
      }
      if (range > 0 && isPlayerTurn && this instanceof Player) {
        Point topLeft = new Point(location.x - range - 1, location.y - range - 1);
        for (int i = topLeft.y; i < location.y + range + 2; i++) {
          for (int j = topLeft.x; j < location.x + range + 2; j++) {
            IGraphSearch pathFinder = new GraphSearch_Astar(graph);
            pathFinder.search(i * (WIDTH / SIZE) + j, location.y * (WIDTH / SIZE) + location.x);
            GraphNode[] route = pathFinder.getRoute();
            if (route.length <= range + 1 && route.length > 0 && (location.x != j || location.y != i)) {
              g.noStroke();
              g.fill(255, 255, 255, 100);
              g.rect(j * SIZE, i * SIZE, SIZE, SIZE);
            }
          }
        }
      }
    }
  }
  int getInitialX(Thing target) {
     int initialX = location.x;
     return initialX;
    /*if (target.getX() > location.x) {
      initialX++;
    } else {
      initialX--;
    }
    return initialX;*/
  }
  void fire(Thing target) {
    swish.play();
    int initialX = getInitialX(target);
    Point temp = new Point(initialX, location.y);
    Arrow arrow = new Arrow(this, target, initialX, location.y);
    arrow.load();
    overlays.add(arrow);
    ArrayList<Thing> tempThings = (ArrayList<Thing>)things.clone();
    for (Thing thing : tempThings) {
      if (thing.isAtPoint(temp)) {
        thing.interact(arrow);
      }
    }
  }
  void hit(Thing target) {
    GraphNode[] route = getRoute(target.getLocation());
    if (route.length <= 2 && route.length > 0) {
      target.suffer(meleeDamage);
    }
  }
  boolean checkIfHit(Thing target) {
    if (isRanged) {
      int initialX = getInitialX(target);
      Arrow arrow = new Arrow(this, target, initialX, location.y);
      while (true) {
        Thing thing = arrow.checkIfWillHit();
        if (thing != this && (thing instanceof Obstacle || thing instanceof Creature)) {
          return thing == target; 
        }
        arrow.takeStep();
      }
    } else {
      GraphNode[] route = getRoute(target.getLocation());
      return route.length <= 2 && route.length > 0;
    }
  }
  void suffer(int damage) {
    hp -= damage;
    if (hp <= 0) {
      overlays.remove(this);
      die();
    }
  }
  void die() {
    isDead = true;
  }
  void setLocation(Point point) {
    if (point.x > location.x) {
      setFacing(Direction.DIR_RIGHT);
    } else if (point.x < location.x) {
      setFacing(Direction.DIR_LEFT);
    } else if(point.y > location.y) {
      setFacing(Direction.DIR_DOWN);
    } else if (point.y < location.y) {
      setFacing(Direction.DIR_UP);
    }
    super.setLocation(point);
  }
}
