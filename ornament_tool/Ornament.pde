class Ornament {
  
  private int state;
  private PVector position;
  private float size;
  private boolean highlighted;
  private PShape ornament;
  
  public Ornament(PShape o, float x, float y, float s, int st) {
    this.ornament = o;
    this.ornament.disableStyle();
    this.position = new PVector(x,y);
    this.size = s;
    this.highlighted = false;
    this.state = st;    
  }  
  
  public void flip() {
    this.flipHorizontally();
  }

  public void flipHorizontally() {
    this.state = this.getFlippedHorizontally();   
  }

  public int getFlippedVertically() {
    int s = this.state;
    if (s > 0) {
      s -= 5;  
    } else if (s < 0) {
      s += 5;  
    }
    return s;
  }  
  
  public void flipeVertically() {
    this.state = this.getFlippedVertically();  
  }

  public int getFlippedHorizontally() {
    int s = this.state;
    if (s > 0) {
      s = (s-(s%2==0?1:-1))*-1;
    } else if (s < 0) {
      s = (s+(s%2==0?1:-1))*-1;  
    }
    return s;
  }  
  
  public void rotateCW() {
    int s = this.state;
    if (s > 0) {
      s++;
      if (s > 4) s = 1;
    } else if (s < 0) {
      s--;
      if (s < -4) s = -1;
    }
    this.state = s;
  }
  
  public void rotateCCW() {
    int s = this.state;
    if (s > 0) {
      s--;
      if (s < 1) s = 4;
    } else if (s < 0) {
      s++;
      if (s > -1) s = -4;
    }
    this.state = s;    
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
    this.show(g);  
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
 
  public void show(PGraphics c) {
    c.push();
    c.fill(0);
    c.noStroke();
    c.translate(this.position.x+this.size/2,this.position.y+this.size/2);
    switch (this.state){
      case 1:
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case 2:
        c.rotate(HALF_PI);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case 3:
        c.rotate(PI);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case 4:
        c.rotate(PI+HALF_PI);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case -4:
        c.scale(1, -1);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case -3:
        c.rotate(-HALF_PI);
        c.scale(1, -1);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case -2:
        c.rotate(-PI);     
        c.scale(1, -1);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;
      case -1:
        c.rotate(-HALF_PI-PI);
        c.scale(1, -1);
        c.shape(ornament,-this.size/2,-this.size/2,this.size,this.size);
        break;             
    }    
    c.pop();
  }

  public int getState() {
    return this.state;  
  }
  
  public PVector getPosition() {
    return this.position;  
  }  
  
  public float getSize() {
    return this.size;  
  }  
  
  public void resize(float newSize) {
    this.position.x = (this.position.x/this.size)*newSize;
    this.position.y = (this.position.y/this.size)*newSize;
    this.size = newSize;  
  }
  
  public void move(int direction, float ammount) {
    if (direction == UP) {
      this.position.y += ammount;  
    } else if (direction == DOWN) {
      this.position.y -= ammount;  
    } else if (direction == LEFT) {
      this.position.x += ammount;
    } else if (direction == RIGHT) {
      this.position.x -= ammount;  
    }
  }
  
  public void move(float x, float y) {
    this.position.x += x;
    this.position.y += y;
  }

}
