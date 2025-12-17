//A 2D game designed by Edward Collins.
//In each level the player must use the arrow keys to navigate a rocket to land on its landing pad.
//In order to compile and run, this program requires access to the Fisica library by Richard Marxer.

import fisica.*;

Engine engine;
Game game;
FWorld world;
float scale;
PFont myFont ;

void settings() {//set screen size so that aspect ratio = 16 : 9
  int maxW = displayWidth;
  int maxH = displayHeight;
  if (abs( maxH * 16 / 9 - maxW) < 3) fullScreen();
  else if ( maxH * 16 / 9 - maxW < 0) size(maxH * 16 / 9, maxH);
  else size(maxW, maxW * 9 / 16);
}

void setup() {
  scale = width / 1920.0;
  Fisica.init(this);
  engine = new Engine();
}

void draw() {
  scale(scale); //rest of the program assumes dimensions of (1920, 1080)
  engine.control();
}

//events called by fisica
void contactStarted(FContact c) {
  game.contactStarted(c);
}

void contactPersisted(FContact c) {
  game.contactPersisted(c);
}

void contactEnded(FContact c) {
  game.contactEnded(c);
}

void mousePressed() {
  engine.mousePressed();
}

void keyPressed() {
  engine.keyPressed();
}

void keyReleased() {
  engine.keyReleased();
}

void displayStar(float x, float y, float r) {
  int z = int(r*.3);
  for (float i = -PI/10; i < 5; i += TAU/5) {
    triangle(x + r*cos(i), y + r*sin(i), x + z*cos(i + PI/2), y + z*sin(i + PI/2),
      x + z*cos(i - PI/2), y + z*sin(i - PI/2));
  }
}
