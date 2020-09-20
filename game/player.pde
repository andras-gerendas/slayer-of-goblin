class Player extends Creature {
  Player(int x, int y) {
    super(x, y);
    maxHP = 40;
    hp = 40;
    range = 3;
    meleeDamage = 10;
  }
  String getImage() {
    return "player3";
  }
  String getUp() {
    return "player_up";
  }
  String getDown() {
    return "player_down";
  }
  String getBattle() {
    return "player_idle";
  }
  String getBattleUp() {
    return "player_battle_up";
  }
  String getBattleDown() {
    return "player_battle_down";
  }
  void die() {
    if (!isDead) {
      super.die();
      animations.add(new DeathAnim(this));
    }
  }
  void performMove(Point target) {
    super.performMove(target);
    stepGrass.play();
  }
}
