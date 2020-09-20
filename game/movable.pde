abstract class Movable extends Thing implements IDrawable {
  Direction facingDirection = Direction.DIR_RIGHT;
  Movable(int x, int y) {
    super(x, y);
  }
  void draw(PGraphics g) {
    PImage currentImage = image;
    if (facingDirection == Direction.DIR_LEFT || facingDirection == Direction.DIR_RIGHT) {
      if (isInBattle && battle != null) {
        currentImage = battle;
      } else {
        currentImage = image;
      }
    } else if (facingDirection == Direction.DIR_UP) {
      if (isInBattle && battleUp != null) {
        currentImage = battleUp;
      } else if (up != null) {
        currentImage = up;
      }
    } else if (facingDirection == Direction.DIR_DOWN) {
      if (isInBattle && battleDown != null) {
        currentImage = battleDown;
      } else if (down != null) {
        currentImage = down;
      }
    }
    flip(g, currentImage, location.x * SIZE, location.y * SIZE);
  }
  void flip(PGraphics g, PImage image, int x, int y) {
    if (facingDirection == Direction.DIR_RIGHT) {
      g.pushMatrix();
      g.translate(SIZE, 0);
      g.scale(-1, 1);
      g.image(image, -x, y);
      g.popMatrix();
    } else {
      g.image(image, x, y);
    }
  }
  void move(Direction d) {
    Point temp = new Point(location.x, location.y);
    switch(d) {
    case DIR_UP:
      temp.y -= 1;
      break;
    case DIR_LEFT:
      temp.x -= 1;
      break;
    case DIR_RIGHT:
      temp.x += 1;
      break;
    default:
      temp.y += 1;
    }
    if (temp.x < 0) {
      temp.x = 0;
    }
    if (temp.y < 0) {
      temp.y = 0;
    }
    if (temp.x > WIDTH / SIZE - 1) {
      temp.x = WIDTH / SIZE - 1;
    }
    if (temp.y > HEIGHT / SIZE - 1) {
      temp.y = HEIGHT / SIZE - 1;
    }
    boolean canMove = true;
    for (Thing thing : things) {
      if (thing.isAtPoint(temp) && thing != this) {
        canMove = false;
        thing.interact(this);
      }
    }
    ArrayList<Thing> tempOverlays = (ArrayList<Thing>)overlays.clone();
    for (Thing thing : tempOverlays) {
      if (thing.isAtPoint(temp) && thing != this) {
        canMove = false;
        thing.interact(this);
      }
    }
    if (canMove) {
      performMove(temp);
    }
  }
  void performMove(Point target) {
    updateFacing(target);
    location.x = target.x;
    location.y = target.y;
  }
  void updateFacing(Point target) {
    if (target.x > location.x) {
      facingDirection = Direction.DIR_RIGHT;
    } else if (target.x < location.x) {
      facingDirection = Direction.DIR_LEFT;
    }
    if (up != null && down != null) {
      if (target.y > location.y) {
        facingDirection = Direction.DIR_DOWN;
      } else if (target.y < location.y) {
        facingDirection = Direction.DIR_UP;
      }
    }
  }
  void setFacing(Direction dir) {
    facingDirection = dir;
  }
}
