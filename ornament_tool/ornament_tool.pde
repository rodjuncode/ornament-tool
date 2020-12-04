import processing.svg.*; //<>//

float gridSize = 200;
ArrayList<Ornament> ornaments;
boolean dragging = false;
PVector dragStart;
int mode, prevMode = 0;
PShape ornament;
PVector moveStartPoint;
PVector prevMovingMouse;
int loop = 0;
int speed = 10;
boolean play = false;
boolean showGrid = false;

void setup() {
  size(1000, 1000); 
  ornaments = new ArrayList<Ornament>();
  selectInput("Selecione o arquivo SVG do ornamento:", "init");
}

void init(File selection) {
  if (selection == null) {
    println("Usuário não selecionou um arquivo para o ornamento. Por favor, inicialize novamente a aplicação.");
  } else {
    ornament = loadShape(selection.getAbsolutePath());
    mode = 1;
  }
}

void draw() {
  loop++;
  background(255);
  if (showGrid) {
    push();
    strokeWeight(1);
    stroke(#DEDEE0);
    for (int i = 0; i <= width; i+= gridSize) {
      line(0,i,width,i);   
    }
    for (int i = 0; i <= height; i+= gridSize) {
      line(i,0,i,height);
    }
    pop();
  }
  if (mode > 0) {
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).show();
    }

    if (dragging) {
      push();
      noFill();
      stroke(0, 255, 0);
      strokeWeight(1);
      rect(dragStart.x, dragStart.y, mouseX-dragStart.x, mouseY-dragStart.y);
      pop();
      if (mode == 2) {
        for (int i = 0; i < ornaments.size(); i++) {
          if (ornaments.get(i).isSelected(dragStart.x, dragStart.y, mouseX, mouseY)) {
            ornaments.get(i).highlightOn();
          } else {
            ornaments.get(i).highlightOff();
          }
        }
      }
    }
  }
  if (mode == 1) {
    push();
    strokeWeight(1);
    stroke(0);
    noFill();
    rect(floor(mouseX/gridSize)*gridSize, floor(mouseY/gridSize)*gridSize, gridSize, gridSize);
    pop();
  } else if (mode == 3) {
    if (moveStartPoint != null) {
      PVector movingMouse = new PVector(mouseX,mouseY);
      if (movingMouse.dist(prevMovingMouse) > 0) {
        PVector newPos = PVector.sub(moveStartPoint,movingMouse).mult(-1);
        for (int i = 0; i < ornaments.size(); i++) {
          ornaments.get(i).move(gridSize*floor(newPos.x),gridSize*(newPos.y));
        }     
      }
      prevMovingMouse = new PVector(movingMouse.x,movingMouse.y);
      moveStartPoint = new PVector(movingMouse.x,movingMouse.y);
    }
  }
  if (play && loop % speed == 0) {
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).rotateCW();
    }     
  }
}

void mousePressed() {
  if (mode == 1) {
    boolean clicked = false;
    for (int i = 0; i < ornaments.size(); i++) {
      if (ornaments.get(i).isClicked(mouseX, mouseY)) {
        if (mouseButton == LEFT) {
          ornaments.get(i).rotateCW();
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
      Ornament o = new Ornament(ornament, floor(mouseX/gridSize)*gridSize, floor(mouseY/gridSize)*gridSize, gridSize, 1);
      ornaments.add(o);
    }
  } else if (mode == 2) {
    if (mouseButton == LEFT) {
      dragging = true;
      dragStart = new PVector(mouseX, mouseY);
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
        right = Math.max(pos.x+size, right);
        left = Math.min(pos.x, left);
        bottom = Math.max(pos.y+size, bottom);
        top = Math.min(pos.y, top);
      }
      if (mouseX > right) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newX = right + abs(right - (oldO.getPosition().x + oldO.getSize()));
          Ornament o = new Ornament(ornament, newX, oldO.getPosition().y, highlighted.get(i).getSize(), oldO.getFlippedHorizontally());  
          ornaments.add(o);
        }
      }
      if (mouseX < left) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newX = left - abs(left - (oldO.getPosition().x + oldO.getSize()));
          Ornament o = new Ornament(ornament, newX, oldO.getPosition().y, highlighted.get(i).getSize(), oldO.getFlippedHorizontally());  
          ornaments.add(o);
        }
      }
      if (mouseY < top) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newY = top - abs(top - (oldO.getPosition().y + oldO.getSize()));
          Ornament o = new Ornament(ornament, oldO.getPosition().x, newY, highlighted.get(i).getSize(), oldO.getFlippedVertically());  
          ornaments.add(o);
        }
      }
      if (mouseY > bottom) {
        for (int i = 0; i < highlighted.size(); i++) {
          Ornament oldO = highlighted.get(i);
          float newY = bottom + abs(bottom - (oldO.getPosition().y + oldO.getSize()));
          Ornament o = new Ornament(ornament, oldO.getPosition().x, newY, highlighted.get(i).getSize(), oldO.getFlippedVertically());  
          ornaments.add(o);
        }
      }
    }
  } else if (mode == 3) {
    if (moveStartPoint == null) {
      moveStartPoint = new PVector(mouseX,mouseY);
      prevMovingMouse = new PVector(mouseX,mouseY);
    }
  }
}

void mouseReleased() {
  dragging = false;
  moveStartPoint = null;
}

void keyPressed() {
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
  } else if (keyCode == UP || keyCode == DOWN || keyCode == RIGHT || keyCode == LEFT) {
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).move(keyCode,gridSize);
    }     
  //} else if (keyCode == 32) {
  //  if (mode != 3) {
  //    prevMode = mode;
  //    mode = 3;
  //  }
  //  cursor(MOVE);
  } else if (key == 'g') {
    showGrid = !showGrid;  
  } else if (key == 'p') {
    play = !play;  
  } else if (key == '[') {
    speed++;
  } else if (key == ']') {
    speed--; 
    if (speed < 1) speed = 1;
  } else if (key == 's') {
    PGraphics svg = createGraphics(width, height, SVG, "result.svg");
    svg.beginDraw();
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).show(svg);
    }
    svg.dispose();
    svg.endDraw();
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) {
    gridSize += 5;
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).resize(gridSize);
    }
  } else if (e > 0) {
    if (gridSize > 5) {
      gridSize -= 5;
    }
    for (int i = 0; i < ornaments.size(); i++) {
      ornaments.get(i).resize(gridSize);
    }    
  }
}

void keyReleased() {
  if (mode == 3) {
    mode = prevMode;
    prevMode = 0;
  }
  cursor(ARROW);
}
