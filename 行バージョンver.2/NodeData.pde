int nodeSum = 0;//ノードの数のカウント
HashMap<Integer, Integer> nodelimitPerRow = new HashMap<>();

void NodeDataSet() {
  int nodeid = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < nodelimitPerRow.get(y); x++) {
      nodeSum++;
    }
  }

  if (nodeSum > nodeid) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < nodelimitPerRow.get(y); x++) {
        float drawPosX = x * cellSize - nodelimitPerRow.get(y) * cellSize / 2 + width / 2 + cellSize / 2;
        float drawPosY = y * cellSize + cellSize /2;
        nodeData.add(new Node(nodeid, x, y, drawPosX, drawPosY));
        nodeid++;
      }
    }
  }
}

void NodeCheck() {
  for (Node n : nodeData) {
    println(n.getId(), n.getDistX(), n.getDistY(), n.getX(), n.getY());
  }
}

void NodeLimitSet() {
  nodelimitPerRow.put(0, 1);
  nodelimitPerRow.put(1, 2);
  nodelimitPerRow.put(2, 3);
  nodelimitPerRow.put(3, 1);
  nodelimitPerRow.put(4, 2);
  nodelimitPerRow.put(5, 6);
  nodelimitPerRow.put(6, 1);
  nodelimitPerRow.put(7, 5);
  nodelimitPerRow.put(8, 5);
  nodelimitPerRow.put(9, 1);
  nodelimitPerRow.put(10, 1);
  nodelimitPerRow.put(11, 1);
  nodelimitPerRow.put(12, 1);
  nodelimitPerRow.put(13, 1);
}
