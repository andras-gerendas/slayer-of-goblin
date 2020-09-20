int ARROW_SPEED = 8;

class Arrow extends Movable implements ISteppable {
  Thing source;
  Thing target;
  Arrow(Thing source, Thing target, int x, int y) {
    super(x, y);
    location.x *= SIZE;
    location.y *= SIZE;
    println(location.x + " " + location.y);
    this.source = source;
    this.target = target;
    if (target.getX() < x) {
      facingDirection = Direction.DIR_LEFT;
    }
  }
  String getImage() {
    return "arrow";
  }
  void draw(PGraphics g) {
    flip(g, image, location.x, location.y);
  }
  void takeStep() {
    Point translated = (Point)target.getLocation().clone();
    translated.x *= SIZE;
    translated.y *= SIZE;
    if (location.x != translated.x || location.y != translated.y) {
      //float rad = atan2(abs(location.x - translated.x), abs(location.y - translated.y));
      if (location.y != translated.y) {
        if (location.y > translated.y) {
          location.y -= ARROW_SPEED; //* sin(rad);
        } else if(location.y < translated.y) {
          location.y += ARROW_SPEED; //* sin(rad);
        }
      }
      if (location.x != translated.x) {
        if (location.x > translated.x) {
          location.x -= ARROW_SPEED; //* cos(rad);
        } else if (location.x < translated.x) {
          location.x += ARROW_SPEED; //* cos(rad);
        }
      }
    }    
  }
  Thing checkIfWillHit() {
    Point translated = (Point)target.getLocation().clone();
    translated.x *= SIZE;
    translated.y *= SIZE;
    if (location.x != translated.x || location.y != translated.y) {
      Point checkLocation = (Point)location.clone();
      checkLocation.x /= SIZE;
      checkLocation.y /= SIZE;
      ArrayList<Thing> tempThings = (ArrayList<Thing>)things.clone();
      for (Thing thing : tempThings) {
        if ((thing instanceof Obstacle || thing instanceof Creature) && thing.isAtPoint(checkLocation) && thing != source) {
          return thing;
        }
      }
      ArrayList<Thing> tempOverlays = (ArrayList<Thing>)overlays.clone();
      for (Thing thing : tempOverlays) {
        if ((thing instanceof Obstacle || thing instanceof Creature) && thing.isAtPoint(checkLocation) && thing != source) {
          return thing;
        }
      }
      updateFacing(translated);
    } else {
      return target;
    }
    return null;
  }
  void step() {
    takeStep();
    Thing thing = checkIfWillHit();
    if (thing == null) {
      return;
    }
    if (thing == target) {
      overlays.remove(this);
    }
    thing.interact(this);
    thing.suffer(6);
  }
  void seeObstacle(Thing other) {
    overlays.remove(this);
  }
  void performMove(Point target) {
  }
}
