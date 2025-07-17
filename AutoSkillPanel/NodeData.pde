ArrayList<Node> nodeData = new ArrayList<>();//ノードデータの保存

void NodeDataSet() {
  int id = 0;
  
  for (int x = 0; x < nodelimitPerRow.size(); x++) {
      rows++;
    }
  
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < nodelimitPerRow.get(y); x++) {
      nodeSum++;
    }
  }

  if (nodeSum > id) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < nodelimitPerRow.get(y); x++) {
        float drawPosX = x * cellSize * 2 - nodelimitPerRow.get(y) * cellSize + width / 2 + cellSize / 2;
        float drawPosY = y * cellSize * 1.5 + cellSize / 2;
        if(x % 2 == 0) drawPosY -= cellSize / 8;
        if(x % 2 != 0) drawPosY += cellSize / 8;
        nodeData.add(new Node(id, x, y, drawPosX, drawPosY));
        id++;
      }
    }
  }
}
