class Box {
  float x,y,z;
  boolean counted;
  int score;
  int hue;
  
  Box(float x,float y,float z,int score,int hue){
    this.x = x;
    this.y = y;
    this.z = z;
    counted = false;
    this.score = score;
    this.hue = hue;
  }

  void display(){
    //lights();
    pushMatrix();
    fill(hue,100,100);
    translate(x,y,z);
    box(200,50,400);
    popMatrix();
    
    z+=35;
  }
  
  void counted(){
    counted = true;
  }
  
  boolean getCounted(){
    return counted;
  }
  
  float getY(){
    return y;
  }
  
  float getZ(){
    return z;
  }
}