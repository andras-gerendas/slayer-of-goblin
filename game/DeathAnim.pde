class DeathAnim extends TextAnim {
  Creature creature;
  DeathAnim(Creature creature) {
    this.creature = creature;
    length = 60;
  }
  void draw(PGraphics g) {
    super.draw(g);
    if (frame == 1) {
      if (creature instanceof Player) {
        animations.add(new BattleLost());
        p1.isDead = false;
      } else {
        animations.add(new BattleWon());
      }
      goblinDeath.play();
    }
    if (frame == 59) {
      isInBattle = false;
      loadMap("map.txt");
      if (!(creature instanceof Player)) {
        overlays.remove(creature);
        p1.setLocation(overWorldLocation);
        p1.setFacing(Direction.DIR_DOWN);
      } else {
        p1.setLocation(new Point(0, 0));
        p1.setFacing(Direction.DIR_RIGHT);
        p1.hp = p1.maxHP;
        g1.setLocation(new Point(8, 4));
        g1.setFacing(Direction.DIR_RIGHT);
        g1.hp = g1.maxHP;
      }
    }
  }
}
