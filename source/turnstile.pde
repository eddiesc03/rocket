//this class also controls the sliders

class Turnstile extends Bonus {

  FBox t;
  float theta = 0;
  boolean slider;

  Turnstile(float x, float y, float r, float value) {
    super(x, y, r, "turnstile", value);
    init();
  }

  Turnstile(float x, float y, float r, float value, float value2) {
    super(x, y, r, "turnstile", value, value2 * PI);
    slider = true;
    init();
  }

  void init() { //initialises either a slider or a turnstile. A negative radius will make the object
    // start 90 deg out of order for turnstile and will cause slider to move horizontally
    if (r > 0)t = new FBox(10, abs(r)*2);
    else t = new FBox(abs(r)*2, 10);
    t.setPosition(pos.x, pos.y);
    t.setFill(0);
    t.setFriction(0);
    t.setGrabbable(false);
    t.setStatic(true);
    t.setName("turnstile");
    world.add(t);
  }

  void control(PVector rocketPos) {
    if (slider) {
      if (r > 0) {
        t.setPosition(pos.x, pos.y + cos(value2)*r);
      } else {
        t.setPosition(pos.x + cos(value2)*r, pos.y);
      }
      value2 += value;
    } else {//turnstile
      t.setRotation(theta);
      if (value != 0) theta += value;
    }
  }

  FBody getBody() {
    return t;
  }
}
