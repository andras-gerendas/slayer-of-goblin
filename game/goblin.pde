class Goblin extends Monster {
  Goblin(int x, int y) {
    super(x, y);
    hp = 26;
    maxHP = 26;
    range = 3;
  }
  String getImage() {
    return "goblin";
  }
  String getBattleUp() {
    return "goblin_up";
  }
  String getBattleDown() {
    return "goblin_down";
  }
  String getBattle() {
    return "goblin_battle";
  }
  void interact(Thing other) {
    if (isInBattle) {
      other.seeObstacle(this);
    } else {
      isInBattle = true;
      battleCreatures.clear();
      overWorldLocation = p1.getLocation();
      p1.setLocation(new Point(16, 7));
      p1.setFacing(Direction.DIR_LEFT);
      g1.setLocation(new Point(3, 7));
      g1.setFacing(Direction.DIR_RIGHT);
      battleCreatures.add(this);
      loadMap("battle.txt");
      Wolf wolf = new Wolf(3, 9);
      wolf.load();
      overlays.add(wolf);
      battleCreatures.add(wolf);
      Spider spider = new Spider(3, 5);
      spider.load();
      overlays.add(spider);
      battleCreatures.add(spider);
      animations.add(new BeginBattle());
    }
  }
  void die() {
    super.die();
    animations.add(new DeathAnim(this));
  }
}
