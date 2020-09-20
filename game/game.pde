import processing.sound.*; //<>//
import pathfinder.*;

PGraphics pg;
PFont font;
SoundFile goblinDeath;
SoundFile swish;
SoundFile win;
SoundFile stepGrass;
Graph graph;

PImage cursor;
PImage cursorSword;
PImage cursorArrow;
PImage cursorError;
PImage cursorStep;

int WIDTH = 320;
int HEIGHT = 240;
int SIZE = 16;
boolean isInBattle = false;
boolean isPlayerTurn = true;

Point overWorldLocation = new Point(0, 0);

Player p1 = new Player(0, 0);
Goblin g1 = new Goblin(8, 4);
GoldBar gold = new GoldBar(5, 14);
ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<Creature> battleCreatures = new ArrayList<Creature>();
ArrayList<Animation> animations = new ArrayList<Animation>();
ArrayList<Thing> overlays = new ArrayList<Thing>();

void loadMap(String name) {
  things.clear();
  overlays.clear();
  graph = new Graph();
  String[] lines = loadStrings(name);
  int nodeID = 0;
  for (int i = 0; i < HEIGHT / SIZE; i++) {
    if (lines.length > i) {
      for (int j = 0; j < WIDTH / SIZE; j++) {
        if (lines[i].length() > j) {
          char tile = lines[i].charAt(j);
          Thing thing = null;
          if (tile == 'Z') {
            thing = new Grass(j, i);
          } else if (tile == 'F') {
            thing = new Forest(j, i);
          } else if (tile == 'R') {
            thing = new Road(j, i);
          } else if (tile == 'S') {
            thing = new Stone(j, i);
          } else if (tile == 'B') {
            thing = new Barrel(j, i);
          } else if (tile == 'G') {
            thing = new Bush(j, i);
          }
          if (thing != null) {
            thing.node = new GraphNode(nodeID, j, i);
            graph.addNode(thing.node);
            nodeID++;
            things.add(thing);
          }
        }
      }
    }
  }
  for (int i = 0; i < HEIGHT / SIZE; i++) {
    for (int j = 0; j < WIDTH / SIZE; j++) {
      Thing thing = things.get(i * (WIDTH / SIZE) + j);
      if (thing != null) {
        if (!(thing instanceof Obstacle)) {
          for (int edgeY = i - 1; edgeY < i + 2; edgeY++) {
            for (int edgeX = j - 1; edgeX < j + 2; edgeX++) {
              if ((edgeX != j || edgeY != i) && edgeX >= 0 && edgeY >= 0) {
                int source = edgeY * (WIDTH / SIZE) + edgeX;
                int dest = i * (WIDTH / SIZE) + j;
                if (source < things.size() && !(things.get(source) instanceof Obstacle)) {
                  graph.addEdge(source, dest, 0, 0);
                }
              }
            }
          }
        }
      }
    }
  }
  overlays.add(gold);
  overlays.add(p1);
  overlays.add(g1);
  for (Thing thing : things) {
    thing.load();
  }
  for (Thing thing : overlays) {
    thing.load();
  }
}

void setup() {
  frameRate(30);
  fullScreen(P2D);
  pg = createGraphics((int)WIDTH, (int)HEIGHT);
  cursor = loadImage("cursor_idle.png");
  cursorSword = loadImage("cursor_sword.png");
  cursorArrow = loadImage("cursor_arrow.png");
  cursorError = loadImage("cursor_error.png");
  cursorStep = loadImage("cursor_step.png");
  font = createFont("Monospaced", 32);
  loadMap("map.txt");
  goblinDeath = new SoundFile(this, "goblin_death.wav");
  swish = new SoundFile(this, "swish-1.wav");
  win = new SoundFile(this, "win.wav");
  stepGrass = new SoundFile(this, "step_grass.wav"); 
  graph = new Graph();
  noCursor();
  animations.add(new GameStart());
}

void draw() {
  if (frameCount % 150 == 0 && !isInBattle) {
    loadMap("map.txt");
  }
  pg.beginDraw();
  pg.background(#90b35b);
  pg.stroke(255);
  pg.point(mouseX * (WIDTH / width), mouseY * (HEIGHT / height));
  ArrayList<Thing> tempThings = (ArrayList<Thing>)things.clone();
  for (Thing thing : tempThings) {
    thing.draw(pg);
  }
  ArrayList<Thing> tempOverlays = (ArrayList<Thing>)overlays.clone();
  for (Thing thing : tempOverlays) {
    thing.draw(pg);
    if (thing instanceof ISteppable) {
      ((ISteppable)thing).step();
    }
  }
  if (isInBattle && animations.size() == 0) {
    PImage cursorImage = cursor;
    if (isPlayerTurn) {
      Point mouseLocation = new Point((int)(mouseX * ((float)WIDTH / width)), (int)(mouseY * ((float)HEIGHT / height)));
      Point translated = (Point) mouseLocation.clone();
      mouseLocation.translate();
      //pg.text(mouseLocation.x + " " + mouseLocation.y, 50, 30);
      pg.noFill();
      pg.stroke(#FFFFFF);
      boolean isColored = false;
      for (Thing thing : tempOverlays) {
        if (thing.isAtPoint(mouseLocation)) {
          if (thing instanceof Monster) {
            pg.stroke(#FF0000);
            isColored = true;
            IGraphSearch pathFinder = new GraphSearch_Astar(graph);
            pathFinder.search(mouseLocation.y * (WIDTH / SIZE) + mouseLocation.x, p1.getY() * (WIDTH / SIZE) + p1.getX());
            GraphNode[] route = pathFinder.getRoute();
            if (route.length == 2) {
              cursorImage = cursorSword;
            } else {
              cursorImage = cursorArrow;
            }
          }
        }
      }
      if (!isColored) {
        IGraphSearch pathFinder = new GraphSearch_Astar(graph);
        pathFinder.search(mouseLocation.y * (WIDTH / SIZE) + mouseLocation.x, p1.getY() * (WIDTH / SIZE) + p1.getX());
        GraphNode[] route = pathFinder.getRoute();
        if (route.length <= p1.range + 1 && route.length > 0) {
          pg.stroke(#00FF00);
          cursorImage = cursorStep;
          isColored = true;
        }
      }
      if (!isColored && mousePressed) {
        cursorImage = cursorError;
      }
      pg.rect(mouseLocation.x * SIZE, mouseLocation.y * SIZE, SIZE, SIZE);
      pg.image(cursorImage, translated.x, translated.y);
    } else {
      for (Creature creature : battleCreatures) {
        if (!creature.isDead) {
          if (creature.checkIfHit(p1)) {
            if (creature.isRanged) {
              creature.fire(p1);
            } else {
              creature.hit(p1);
            }
          } else {
            GraphNode[] route = creature.getRoute(p1.getLocation());
            if (route.length > 1) {
              int range = creature.range + 1;
              if (route.length < creature.range + 1) {
                range = route.length;
              }
              GraphNode target = route[range - 2];
              creature.setLocation(new Point((int)target.x(), (int)target.y()));
            }
          }
        }
      }
      isPlayerTurn = true;
    }
  }
  ArrayList<Animation> tempAnimations = (ArrayList<Animation>)animations.clone();
  for (Animation animation : tempAnimations) {
    animation.draw(pg);
  }
  int id = 0;
  for (int i = 0; i < HEIGHT / SIZE; i++) {
    for (int j = 0; j < WIDTH / SIZE; j++) {
      pg.textSize(8);
      pg.textAlign(CENTER);
      //pg.text(id, j * SIZE + SIZE / 2, i * SIZE + SIZE / 2);
      id++;
    }
  }
  pg.fill(255);
  pg.stroke(255);
  for (GraphEdge edge : graph.getAllEdgeArray()) {
    //pg.line(edge.from().xf() * SIZE + SIZE / 2, edge.from().yf() * SIZE + SIZE / 2, edge.to().xf() * SIZE + SIZE / 2, edge.to().yf() * SIZE + SIZE / 2);
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  //image(pg, 0, 0, 1024, 768);
}

void keyPressed() {
  if (animations.size() > 0 || isInBattle) {
    return;
  }
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      p1.move(Direction.DIR_UP);
      break;
    case LEFT:
      p1.move(Direction.DIR_LEFT);
      break;
    case RIGHT:
      p1.move(Direction.DIR_RIGHT);
      break;
    case DOWN:
      p1.move(Direction.DIR_DOWN);
      break;
    default:
      break;
    }
  }
}

void mousePressed() {
  if (animations.size() > 0) {
    return;
  }
  if (isInBattle && isPlayerTurn) {
    Point mouseLocation = new Point((int)(mouseX * ((float)WIDTH / width)), (int)(mouseY * ((float)HEIGHT / height)));
    mouseLocation.translate();
    boolean isActionCarriedOut = false;
    ArrayList<Thing> tempThings = (ArrayList<Thing>)things.clone();
    for (Thing thing : tempThings) {
      if (thing.isAtPoint(mouseLocation) && thing instanceof Monster) {
        IGraphSearch pathFinder = new GraphSearch_Astar(graph);
        pathFinder.search(mouseLocation.y * (WIDTH / SIZE) + mouseLocation.x, p1.getY() * (WIDTH / SIZE) + p1.getX());
        GraphNode[] route = pathFinder.getRoute();
        if (route.length == 2) {
          p1.hit(thing);
        } else {
          p1.fire(thing);
        }
        isActionCarriedOut = true;
      }
    }
    ArrayList<Thing> tempOverlays = (ArrayList<Thing>)overlays.clone();
    boolean isHit = false;
    for (Thing thing : tempOverlays) {
      if (thing.isAtPoint(mouseLocation) && thing instanceof Monster) {
        IGraphSearch pathFinder = new GraphSearch_Astar(graph);
        pathFinder.search(mouseLocation.y * (WIDTH / SIZE) + mouseLocation.x, p1.getY() * (WIDTH / SIZE) + p1.getX());
        GraphNode[] route = pathFinder.getRoute();
        if (route.length == 2) {
          p1.hit(thing);
          isHit = true;
        } else {
          p1.fire(thing);
          isHit = true;
        }
        isActionCarriedOut = true;
      }
      if (isHit) {
        break;
      }
    }

    if (!isActionCarriedOut) {
      IGraphSearch pathFinder = new GraphSearch_Astar(graph);
      pathFinder.search(mouseLocation.y * (WIDTH / SIZE) + mouseLocation.x, p1.getY() * (WIDTH / SIZE) + p1.getX());
      GraphNode[] route = pathFinder.getRoute();
      if (route.length <= p1.range + 1 && route.length > 0) {
        p1.setLocation(mouseLocation);
        if (stepGrass.isPlaying()) {
          stepGrass.stop();
        }
        stepGrass.play();
        isActionCarriedOut = true;
      }
    }

    if (isActionCarriedOut) {
      isPlayerTurn = false;
    }
  }
}
