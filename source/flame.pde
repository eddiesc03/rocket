class Flame{
 
  float x, y, size, noise, angle;
  
  Flame(float x, float y, float size, float angle, float noise){
    this.x = x;
    this.y = y;
    this.size = size;
    this.angle = angle;
    this.noise = noise;
  }
  
  void control(){
    fill(150 + noise(noise+300)*100, 100 + noise(noise+200)*100, 0, size*10);
    circle(x,y,(1+noise(noise+1000))*10);
    size -= .1;
    noise += .05;
    x += 3*(noise(noise)-.5) + cos(angle)*1.5;
    y += 3*(noise(noise+100)) - 1 + sin(angle)*1.5;
  }
}
