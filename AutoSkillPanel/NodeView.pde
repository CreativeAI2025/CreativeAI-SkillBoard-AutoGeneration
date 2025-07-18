void NodeView() {
  DrawNodes();//ノードの表示
  DrawId();//IDの表示
}

void DrawNodes() {
  for (Node n : nodeData) {
    fill(255);
    if (n.getId() == 0) fill(255, 255, 0);
    ellipse(n.getX(), n.getY(), cellSize, cellSize);
  }
}

void DrawId() {
  for (Node n : nodeData) {
    float drawPosX = n.getX();
    float drawPosY = n.getY();
    
    fill(0);
    
    textSize(16);
    textAlign(CENTER,CENTER);
    text(n.getId()+ ":" + n.getDistX() + "," + n.getDistY(), drawPosX, drawPosY);
  }
}
