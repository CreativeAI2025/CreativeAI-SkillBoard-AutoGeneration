ArrayList<Node> nodeData = new ArrayList<>();//ノードデータの保存

void NodeDataSet() {
  int id = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < nodelimitPerRow.get(y); x++) {
      nodeSum++;
    }
  }

  if (nodeSum > id) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < nodelimitPerRow.get(y); x++) {
        float drawPosX = x * cellSize - nodelimitPerRow.get(y) * cellSize / 2 + width / 2 + cellSize / 2;
        float drawPosY = y * cellSize + cellSize /2;
        nodeData.add(new Node(id, x, y, drawPosX, drawPosY));
        id++;
      }
    }
  }
}
