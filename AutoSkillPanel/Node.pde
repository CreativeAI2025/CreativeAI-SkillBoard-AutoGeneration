class Node {
  int id;
  float x;
  float y;
  int distX;
  int distY;

  private String tag;//タグ名（スキルorステータス）

  Node(int id, int dist_x, int dist_y, float x, float y) {//コンストラクタ(ノード描写用)
    this.id = id;
    this.distX = dist_x;
    this.distY = dist_y;
    this.x = x;
    this.y = y;
  }

  Node(int id, String tag) {//コンストラクタ（スキル・ステータス用）
    this.id = id;
    this.tag = tag;
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

  public String getTag() {
    return this.tag;
  }
}

void NodeCheck() {
  for (Node n : nodeData) {
    //println(n.getId(), n.getX(), n.getY(), n.getDistX(), n.getDistY());
  }

  for (int i = 0; i < tagData.size(); i++) {
    //println("ID:" + i + "タグ名:"+ tagData.get(i));
  }

  for (Skill s : nodeSkillData) {
    //println(s.toSkillString(s.type));
    //println(s);
  }
  
  for (Node n1 : nodeData) {
    for (Node n2 : nodeData) {
      //println(n1.getId() + "," + n2.getId( )+ " 距離" + nodeDistanceSherch(n1.getId(),n2.getId()));
    }
  }
}
