ArrayList<Node> lineData = new ArrayList<>();//ラインデータの保存
ArrayList<int[]> connections = new ArrayList<int[]>();// IDの遷移を記録

void LineDataSet() {
  connections.clear();  // 前回の接続をリセット

  for (Node n1 : nodeData) {
    for (Node n2 : nodeData) {
      if (pointInCircle(n2.getX(),n2.getY(),n1.getX(),n1.getY(),cellSize * 1.5) && n1.getId() != n2.getId()) {
        connections.add(new int[]{n1.getId(), n2.getId()});
      }
    }
  }
}

boolean pointInCircle(float px, float py, float cx, float cy, float r) {
  float dx = px - cx;
  float dy = py - cy;
  return dx*dx + dy*dy <= r*r;
}
