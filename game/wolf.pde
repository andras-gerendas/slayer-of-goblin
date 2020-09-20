class Wolf extends Monster {
  Wolf(int x, int y) {
    super(x, y);
    hp = 6;
    maxHP = 6;
    range = 6;
    isRanged = false;
    meleeDamage = 12;
  }
  String getImage() {
    return "wolf";
  }
  String getUp() {
    return "wolf_up";
  }
  String getDown() {
    return "wolf_down";
  }
  void interact(Thing other) {
    if (isInBattle) {
      other.seeObstacle(this);
    }
  }
  void die() {
    super.die();
  }
}
