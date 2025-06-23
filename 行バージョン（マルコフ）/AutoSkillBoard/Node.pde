class Node {
  PVector pos;
  int dist;
  int x, y;
  int mp; // MP（コスト）

  Node(PVector pos, int dist, int x, int y, int mp) {
    this.pos = pos;
    this.dist = dist;
    this.x = x;
    this.y = y;
    this.mp = mp;
  }
}
