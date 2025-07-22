void lineView() {
  drawLine();
}

void drawLine() {//IDを参照し線を結ぶ
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];

    //println(from + " → " + to);//変移
    //println(pair);

    float currentX = nodeData.get(from).getX();
    float currentY = nodeData.get(from).getY();
    float nextX = nodeData.get(to).getX();
    float nextY = nodeData.get(to).getY();

    stroke(from * 20, 0, 200);
    line(currentX, currentY, nextX, nextY);
  }
}

int nodeDistanceSherch(int nowid, int nextid) {//最短距離を求める
  if (nowid == nextid) return 0;

  HashSet<Integer> visited = new HashSet<Integer>();
  LinkedList<int[]> queue = new LinkedList<int[]>();

  // {現在のノードID, 現在までの距離}
  queue.add(new int[]{nowid, 0});
  visited.add(nowid);

  while (!queue.isEmpty()) {
    int[] current = queue.poll();
    int currentId = current[0];
    int distance = current[1];

    // connectionsからcurrentIdに隣接するノードを探す
    for (int[] pair : connections) {
      int neighbor = -1;
      if (pair[0] == currentId) {
        neighbor = pair[1];
      } else if (pair[1] == currentId) { // 無向グラフとみなす
        neighbor = pair[0];
      }

      if (neighbor != -1 && !visited.contains(neighbor)) {
        if (neighbor == nextid) {
          return distance + 1; // ゴールに到達
        }
        visited.add(neighbor);
        queue.add(new int[]{neighbor, distance + 1});
      }
    }
  }

  // 到達不可能
  return -1;
}

int getPanelSize() {//スキルパネルの大きさの取得
  int max_size = 0;
  
  for (Node n1 : nodeData) {
      if(max_size < nodeDistanceSherch(0,n1.getId())) max_size = nodeDistanceSherch(0,n1.getId());
  }
  
  return max_size;
}
