void nodeView() {
  drawGrid();//グリッドの表示
  drawNodes();//ノードの表示
  drawId();//IDの表示
}

void drawGrid() {//グリッドの表示
  float gridWidth = cols * cellSize;//グリッドの幅
  float startX = width / 2 - gridWidth / 2;//グリッドの始めの位置(中央に寄せるため)
  for (int i = 0; i < rows; i++) {
    fill(150);
    rect(startX, i * cellSize, gridWidth, cellSize);//階層グリッド
    fill(0);
    textAlign(0, CENTER);
    text(i, startX + cellSize / 2, (cellSize/2) + cellSize * i);//階層数
  }
}


void drawNodes() {
  for (Node n : nodeData) {

    if (n.getDistY() == 0) fill(255, 255, 0);
    if (n.getDistY() != 0) fill(255);

    ellipse(n.getX(), n.getY(), cellSize / 1.5, cellSize / 1.5);
  }
}

void drawId() {
  for (Node n : nodeData) {
    float drawPosX = n.getDistX() * cellSize - nodelimitPerRow.get(n.getDistY()) * cellSize / 2 + width / 2 + cellSize / 2;
    float drawPosY = n.getDistY() * cellSize + cellSize /2;

    fill(0);
    textSize(16);
    textAlign(CENTER,CENTER);
    text(n.getId(), drawPosX, drawPosY);
  }
}
