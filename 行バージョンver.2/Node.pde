ArrayList<Node> nodeData = new ArrayList<>();

public class Node {
  private int id;
  private PVector pos;//ノードの実座標
  private int distX, distY;//ノードの探索距離
  private float x, y;//ノードの探索座標
  private int mp; // MP（コスト）
  private int input;
  private int output;
  private int skill;
  private int status;

  Node(int id, int dist_x, int dist_y,float x, float y) {//コンストラクタ
    this.id = id;
    this.distX = dist_x;
    this.distY = dist_y;
    this.x = x;
    this.y = y;
  }

  Node(int id,PVector pos) {
    this.id = id;
    this.pos = pos;
  }

  Node(float x, float y) {//コンストラクタ
    this.x = x;
    this.y = y;
  }

  public int getId() {
    return this.id;
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

  public void setId(int id) {
    this.id = id;
  }
}
