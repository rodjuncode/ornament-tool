float gridSize = 25;
ArrayList<Ornament> ornaments;
boolean dragging = false;
PVector dragStart;
int mode = 1;
float scale = 1;

void setup() {
  size(500,500); 
  ornaments = new ArrayList<Ornament>();
}

void draw() {
  scale(scale);
  background(#0F5EA4);
  strokeWeight(3);
  textSize(gridSize*0.5);
  textAlign(LEFT,TOP);
  for (int i = 0; i < ornaments.size(); i++) {
    ornaments.get(i).show();
  }
  
  if (dragging) {
    push();
    noFill();
    stroke(0,255,0);
    strokeWeight(1);
    rect(dragStart.x,dragStart.y,mouseX-dragStart.x,mouseY-dragStart.y);
    pop();
    if (mode == 2) {
      for (int i = 0; i < ornaments.size(); i++) {
        if (ornaments.get(i).isSelected(dragStart.x,dragStart.y,mouseX,mouseY)) {
          ornaments.get(i).highlightOn();
        } else {
          ornaments.get(i).highlightOff();
        }
      }
    }
  } //<>//
  if (mode == 1) {
      push();
      strokeWeight(1);
      stroke(0);
      noFill();
      rect(floor(mouseX/gridSize)*gridSize,floor(mouseY/gridSize)*gridSize,gridSize,gridSize);
      pop();
  }  
  
}

void mousePressed() {
  if (mode == 1) {
    boolean clicked = false;
    for (int i = 0; i < ornaments.size(); i++) {
      if (ornaments.get(i).isClicked(mouseX,mouseY)) {
        if (mouseButton == LEFT) {
          ornaments.get(i).rotate();
          clicked = true;
          return;
        } else if (mouseButton == RIGHT) {
          ornaments.get(i).flip();
          clicked = true;
          return;
        }
      }
    }
    if (!clicked) {
      Ornament o = new Ornament(floor(mouseX/gridSize)*gridSize,floor(mouseY/gridSize)*gridSize,gridSize);
      ornaments.add(o);
    }
  } else if (mode == 2) {
    if (mouseButton == LEFT) {
      dragging = true;
      dragStart = new PVector(mouseX,mouseY);
    } else if (mouseButton == RIGHT) {
      ArrayList<Ornament> highlighted = new ArrayList<Ornament>();
      for (int i = 0; i < ornaments.size(); i++) {
        if (ornaments.get(i).isHighlighted()) {
          highlighted.add(ornaments.get(i));          
        }
      }
      // look for the cluster's border
      float bottom = -1;
      float right = -1;
      float top = height+1;
      float left = width+1;
      for (int i = 0; i < highlighted.size(); i++) {
        PVector pos = highlighted.get(i).getPosition();
        float size = highlighted.get(i).getSize();
        right = Math.max(pos.x+size,right);
        left = Math.min(pos.x,left);
        bottom = Math.max(pos.y+size,bottom);
        top = Math.min(pos.y,top);
      }
      if (mouseX > right) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newX = right + abs(right - (oldO.getPosition().x + oldO.getSize()));
          Ornament o = new Ornament(newX,oldO.getPosition().y,highlighted.get(i).getSize(),oldO.flipHorizontal());  
          ornaments.add(o);
        }
      }
      if (mouseX < left) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newX = left - abs(left - (oldO.getPosition().x + oldO.getSize()));
          Ornament o = new Ornament(newX,oldO.getPosition().y,highlighted.get(i).getSize(),oldO.flipHorizontal());  
          ornaments.add(o);
        }
      }
      if (mouseY < top) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newY = top - abs(top - (oldO.getPosition().y + oldO.getSize()));
          Ornament o = new Ornament(oldO.getPosition().x,newY,highlighted.get(i).getSize(),oldO.flipVertical());  
          ornaments.add(o);
        }
      }
      if (mouseY > bottom) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newY = bottom + abs(bottom - (oldO.getPosition().y + oldO.getSize()));
          Ornament o = new Ornament(oldO.getPosition().x,newY,highlighted.get(i).getSize(),oldO.flipVertical());  
          ornaments.add(o);
        }
      }      
    }
    
  }
}

void mouseReleased() {
  dragging = false;
}

void keyPressed() {
  println(keyCode);
  if (keyCode  == '1') {
    mode = 1;
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).highlightOff();
    }    
  } else if (keyCode  == '2') {
    mode = 2;
  } else if (keyCode == DELETE) {
    if (mode == 2) {
      ArrayList<Ornament> ornamentsToDelete = new ArrayList<Ornament>();
      for (int i = 0; i < ornaments.size(); i++) {
        if (ornaments.get(i).isHighlighted()) {
          ornamentsToDelete.add(ornaments.get(i));  
        }
      }  
      ornaments.removeAll(ornamentsToDelete);
    }
  } else if (keyCode == 61) {
    scale += .2;
  } else if (keyCode == 45) {
    scale -= .2;    
  }
}
