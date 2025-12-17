//class that controls an alien

class Alien extends Bonus {

  FPoly a;
  int s = 1920/45;
  int timer = 0;

//r = x_speed , value = bullet_force/10000 , value2 = fire frequency.
  Alien(float x, float y, float r, float value, float value2) {
    super(x, y, r, "alien", value, value2);
    a = new FPoly();
    a(.4, -.6);
    a(.6, -.2);
    a(1, 0);
    a(.8, .2);
    a(.6, .3);
    a(0, .4);
    a(-.6, .3);
    a(-.8, .2);
    a(-1, 0);
    a(-.6, -.2);
    a(-.4, -.6);
    a.setPosition(x, y);
    a.setFill(0, 200, 100);
    a.setGrabbable(false);
    a.setStatic(true);
    a.setName("alien");
    world.add(a);
  }

  void a(float x, float y) {//shorthand for a.vertex ... scaled
    a.vertex(x*s, y*s);
  }

  void control(PVector rocketPos) {
    pos.x += r;
    a.setPosition(pos.x, pos.y);//move alien
    timer ++;
    if (timer > value2) {
      timer = 0;
      float a = atan2(rocketPos.y - pos.y,rocketPos.x - pos.x);//angle to rocket
      Bullet b = new Bullet(pos.x, pos.y, a, 5, value * 10000);
      game.obstacles.add(b.getBody());
    }
  }

  FBody getBody() {
    return a;
  }
}
