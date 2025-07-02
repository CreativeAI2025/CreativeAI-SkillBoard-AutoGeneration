void lineView() {
  drawLine();
}

void drawLine() {//IDを参照し線を結ぶ
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];

    println(from + " → " + to);//変移

    float currentX = nodeData.get(from).getX();
    float currentY = nodeData.get(from).getY();
    float nextX = nodeData.get(to).getX();
    float nextY = nodeData.get(to).getY();

    stroke(from * 20, 0,200);
    line(currentX, currentY, nextX, nextY);
  }
}
