//creates the buttons in the menu

class Button {
  float x;
  float y;
  float w;
  float h;
  String s;
  color c;

  Button(float x1, float y1, float w1, float h1, String s1, color c1) {
    x = x1-w1/2;
    y = y1-h1/2;
    w = w1;
    h = h1;
    s = s1;
    c = c1;
  }

  void display() {
    //pushStyle();
    stroke(c);
    strokeWeight(h);
    line(x+h/2, y+h/2, x+w-h/2, y+h/2);
    strokeWeight(1);
    stroke(0);
    fill(0);
    if (s.length() > 2) {
      if (h >= 40) {
        textSize(25);
        textAlign(CENTER);
        textLeading(20);
      } else {
        textSize(20);
        textAlign(CENTER);
        textLeading(18);
      }
      if (c != color(70, 200, 170))text(s, x, y+h/4, w, h);
      else text(s, x, y+h/10, w, h);//'another'
    }
    //popStyle();
  }

  boolean pressed() {
    if (mouseX/scale > x && mouseX/scale < x + w && mouseY/scale > y && mouseY/scale < y + h) return true;
    else return false;
  }
}
