class Bullet extends Bonus {

  FCircle c;
  float v;

  Bullet(float x, float y, float a, float r, float value) {
    //this.v = v;
    super(x, y, r, "bullet", value);
    c = new FCircle(r*2);
    c.setFill(#7C9AC9);
    c.setPosition(x + 50*cos(a), y + 50*sin(a));
    c.setBullet(true);
    world.add(c);
    c.setName("bullet");
    c.addForce(value*cos(a), value*sin(a));
  }

  void control(PVector rocketPos) {
   // float a = game.ship.rocket.getRotation()-PI/2;
    //c.addForce(value*cos(a), value*sin(a));
    //c.setVelocity(
    //c.setPosition
  }

  FBody getBody() {
    return c;
  }
}
