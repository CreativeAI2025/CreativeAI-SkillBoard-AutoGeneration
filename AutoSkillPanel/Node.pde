class Node {
  int id;
  float x;
  float y;
  int distX;
  int distY;

  Node(int id, int dist_x, int dist_y, float x, float y) {//コンストラクタ(ノード描写用)
    this.id = id;
    this.distX = dist_x;
    this.distY = dist_y;
    this.x = x;
    this.y = y;
  }

  public int getId() {
    return this.id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public int getDistX() {
    return this.distX;
  }

  public int getDistY() {
    return this.distY;
  }

  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }
}

void NodeCheck() {
  for (Node n : nodeData) {
    println(n.getId(), n.getX(), n.getY(), n.getDistX(), n.getDistY());
  }
}
