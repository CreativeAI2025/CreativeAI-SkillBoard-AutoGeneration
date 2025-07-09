public class Node {
  private int id;//各ノードのID
  private int distX, distY;//ノードの探索距離
  private float x, y;//ノードの実座標
  private int mp; // MP（コスト）
  private int branch;//枝の数
  private String tag;//タグ名（スキルorステータス）
  private String name;//スキル・ステータスの名前
  private String explain;//スキル・ステータスの情報（文の中に数字とラベルを入れること）

  private int inputCount = 0;   // 入力された回数（どこからか来た回数）
  private int outputCount = 0;  // 出力した回数（どこかへ出した回数）

  Node(int id, int dist_x, int dist_y, float x, float y) {//コンストラクタ(ノード描写用)
    this.id = id;
    this.distX = dist_x;
    this.distY = dist_y;
    this.x = x;
    this.y = y;
  }

  Node(int id, int branch) {//コンストラクタ（ライン描写用）
    this.id = id;
    this.branch = branch;
  }
  
  Node(int id, String tag){//コンストラクタ（スキル・ステータス用）
    this.id = id;
    this.tag = tag;
  }

  Node(String name, String explain) {//コンストラクタ（スキル・ステータス用（詳細情報））
    this.id = 0;
    this.name = name;
    this.explain = explain;
    this.mp = 0;
  }

  public int getId() {
    return this.id;
  }
  
  public void setId(int id){
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

  public int getBranch() {
    return this.branch;
  }
  
  public String getTag() {
    return this.tag;
  }
  
  public int getMp(){
    return this.mp;
  }
  
  public void setMp(int mp){
    this.mp = mp;
  }
}

void NodeCheck() {
  fill(255);
  stroke(0);
  rect(50, 120, 250, 1000);

  //for (Node n : nodeData) {
  //  print("ID:" + n.getId());
  //  print("探索距離:" + n.getDistX() + "," + n.getDistY());
  //  println("実座標:" + n.getX() + "," + n.getY());
  //}

  for (Node n : lineData) {
    //print("ID:" + n.getId());
    //println("入力:"+ n.getInputCount() +"出力:" + n.getOutputCount());

    fill(0);
    textSize(16);
    textAlign(LEFT, CENTER);
    //text("ID:" + n.getId() + "枝:"+ n.getInputCount());
  }
  
  //for(Node n : tagData){
  //  println("ID:" + n.getId() + "タグ名:"+ n.getTag());
  //}
}
