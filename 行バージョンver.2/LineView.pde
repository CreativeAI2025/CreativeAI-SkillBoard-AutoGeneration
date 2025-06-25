void lineView() {
  drawLine();
}

void lineDataSet() {
}

void drawLine() {
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];


    println(from, to);

    float currentX = nodeData.get(from).getX();
    float currentY = nodeData.get(from).getY();
    float nextX = nodeData.get(to).getX();
    float nextY = nodeData.get(to).getY();

    line(currentX, currentY, nextX, nextY);
  }
}

ArrayList<int[]> connections = new ArrayList<int[]>();

// 汎用接続関数：指定した範囲どうしをすべて接続
void connectRange(int fromStart, int fromEnd, int toStart, int toEnd) {
  int row = 0;//階層
  for (int i = fromStart; i <= fromEnd; i++) {
    for (int j = toStart; j <= toEnd; j++) {
      if(0.5 < random(1)) continue;
      connections.add(new int[]{i, j});
    }
    row++;
  }
}

// 接続を作成
void generateRandomConnections() {
  connections.clear();  // 前回の接続をリセット
  int sum = 0;
  
  //nodelimitPerRow.get(y)
  for (int y = 0; y < rows; y++) {
    //connectRange(0, 0, 1, 2);
    //connectRange(0, 0, sum, sum + nodelimitPerRow.get(y));
    
    if(y < rows - 1) println(sum, sum + nodelimitPerRow.get(y) - 1, sum + nodelimitPerRow.get(y), sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    if(y < rows - 1) connectRange(sum, sum + nodelimitPerRow.get(y) - 1, sum + nodelimitPerRow.get(y), sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    sum += nodelimitPerRow.get(y);
  }

  //// 0 → 1,2
  //connectRange(0, 0, 1, 2);

  //// 1,2 → 3,4,5
  //connectRange(1, 2, 3, 5);

  //// 3,4,5 → 6
  //connectRange(3, 5, 6, 6);
}
