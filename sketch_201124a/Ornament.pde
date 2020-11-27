class Ornament {
  
  private int state;
  private PVector position;
  private float size;
  private boolean highlighted;
  
  public Ornament(float x, float y, float s) {
    this.state = ceil(random(8));
    this.position = new PVector(x,y);
    this.size = s;
    this.highlighted = false;
  }
  
  public Ornament(float x, float y, float s, int st) {
    this.state = ceil(random(8));
    this.position = new PVector(x,y);
    this.size = s;
    this.highlighted = false;
    this.state = st;    
  }  
  
  public int getState() {
    return this.state;  
  }
  
  public void flip() {
    this.state = this.flipHorizontal();
  }

  public int flipHorizontal() {
    if (this.state == 1) return 5;
    if (this.state == 2) return 8;
    if (this.state == 3) return 7;
    if (this.state == 4) return 6; 
    if (this.state == 5) return 1;
    if (this.state == 6) return 4;
    if (this.state == 7) return 3;
    if (this.state == 8) return 2;
    return 0;
  }  

  public int flipVertical() {
    if (this.state == 1) return 7;
    if (this.state == 2) return 6;
    if (this.state == 3) return 5;
    if (this.state == 4) return 8;      
    if (this.state == 5) return 3;
    if (this.state == 6) return 2;
    if (this.state == 7) return 1;
    if (this.state == 8) return 4;    
    return 0;
  }  
  
 
  public float getSize() {
    return this.size;  
  }
  
  public void rotate() {
    if (this.state == 4) {
      this.state = 1;
    } else if (this.state == 8) {
      this.state = 5;
    } else {
      this.state++;  
    }
  }
  
  public PVector getPosition() {
    return this.position;  
  }
  
  public boolean isHighlighted() {
    return this.highlighted;
  }
  
  public void highlightOn() {
    this.highlighted = true;  
  }

  public void highlightOff() {
    this.highlighted = false;  
  }  
  
  public boolean isClicked(float x, float y) {
    if (x >= this.position.x && x <= this.position.x+size &&
        y >= this.position.y && y <= this.position.y+size) {
      return true;
    }
    return false;  
  }
  
  public boolean isSelected(float x1, float y1, float x2, float y2) {
    float xMin = Math.min(x1,x2);
    float xMax = Math.max(x1,x2);
    float yMin = Math.min(y1,y2);
    float yMax = Math.max(y1,y2);
    if ((xMax >= this.position.x && xMin <= this.position.x+size) &&
        (yMax >= this.position.y && yMin <= this.position.y+size)) {
      return true; 
    }
    return false;  
  }  
  
  public void show() {
    push();
    noStroke();
    fill(255);
    translate(this.position.x,this.position.y);
    switch (this.state){
        case 1:
              beginShape();
              vertex(0, 0);
              vertex(this.size*.3, 0);
              vertex(0, this.size*.7);
              endShape(CLOSE);            
            break;
        case 2:
              beginShape();
              vertex(this.size*0.3, 0);
              vertex(this.size, 0);
              vertex(this.size, this.size*.3);
              endShape(CLOSE);                
            break;
        case 3:
              beginShape();
              vertex(this.size, this.size*0.3);
              vertex(this.size, this.size);
              vertex(this.size*0.7, this.size);
              endShape(CLOSE);                  
            break;
        case 4:
              beginShape();
              vertex(0,this.size*0.7);
              vertex(this.size*0.7, this.size);
              vertex(0, this.size);
              endShape(CLOSE);                
            break;
        case 5:
              beginShape();
              vertex(this.size*0.7, 0);
              vertex(this.size, 0);
              vertex(this.size, this.size*.7);
              endShape(CLOSE);                
            break;
        case 6:
              beginShape();
              vertex(this.size, this.size*0.7);
              vertex(this.size, this.size);
              vertex(this.size*.3, this.size);
              endShape(CLOSE);                
            break;
        case 7:
              beginShape();
              vertex(0, this.size*.3);
              vertex(this.size*.3, this.size);
              vertex(0, this.size);
              endShape(CLOSE);                
            break;
        case 8:
              beginShape();
              vertex(0, 0);
              vertex(this.size*.7, 0);
              vertex(0, this.size*.3);
              endShape(CLOSE);                
            break;            
    }    
    pop();
    if (this.highlighted) {
      push();
      noFill();
      strokeWeight(1);
      stroke(227,125,15);
      translate(this.position.x,this.position.y);
      rect(0,0,size,size);
      pop();
    }
  }
  

}
