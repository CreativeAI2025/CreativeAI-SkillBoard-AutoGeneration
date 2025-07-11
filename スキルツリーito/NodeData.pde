int nodeSum = 0;//ノードの数のカウント
HashMap<Integer, Integer> nodelimitPerRow = new HashMap<>();

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

void NodeLimitSet() {//各階層でノードの個数の制限
  nodelimitPerRow.put(0, 1);
  nodelimitPerRow.put(1, 2);
  nodelimitPerRow.put(2, 4);
  nodelimitPerRow.put(3, 2);
  nodelimitPerRow.put(4, 7);
  nodelimitPerRow.put(5, 5);
  nodelimitPerRow.put(6, 7);
  nodelimitPerRow.put(7, 3);
  nodelimitPerRow.put(8, 1);
  nodelimitPerRow.put(9, 2);
  nodelimitPerRow.put(10, 1);
  //nodelimitPerRow.put(11, 1);
  //nodelimitPerRow.put(12, 1);
  //nodelimitPerRow.put(13, 1);
}
