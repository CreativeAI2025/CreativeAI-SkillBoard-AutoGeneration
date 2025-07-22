void NodeView() {
  DrawNodes();//ノードの表示
  DrawId();//IDの表示
}

void DrawNodes() {
  for (Node n : nodeData) {

    if (n.getId() == 0) fill(255, 255, 0);
    if (n.getId() != 0){
      if(tagData.get(n.getId()) == "スキル"){
        fill(255,0,0);
      }else if(tagData.get(n.getId()) == "ステータス"){
        fill(0,0,255);
      }else{
        fill(0);
      }
    }

    ellipse(n.getX(), n.getY(), cellSize / 1.5f, cellSize / 1.5f);
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
