class Spider extends Monster {
  Spider(int x, int y) {
    super(x, y);
    hp = 14;
    maxHP = 14;
    range = 5;
    isRanged = false;
    meleeDamage = 14;
  }
  String getImage() {
    return "spider";
  }
  String getUp() {
    return "spider_up";
  }
  String getDown() {
    return "spider_down";
  }
}
