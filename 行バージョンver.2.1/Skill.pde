public class Skill {
  private int id;//各ノードのID
  private String tag;//タグ名（スキルorステータス）
  private String name;//スキル・ステータスの名前
  private String subject;//対象
  private String action;//行動(攻撃、回復など)
  private int power;//効果量
  private String type;//種類（物理攻撃、特殊攻撃など）
  private String extra;//追加効果
  private int duration;//持続ターン
  private int mp; // MP（コスト）

  Skill(String name, String subject, String action, int power, String type, String extra, int duration) {//コンストラクタ（スキル用（詳細情報））
    this.id = 0;//ID
    this.tag = "スキル";//分類
    this.name = name;//名前
    this.subject = subject;//対象
    this.action = action;//行動
    this.power = power;//強さ
    this.type = type;//種類
    this.extra = extra;
    this.duration = duration;
    this.mp = 0;//獲得に必要なコスト
  }

  public String getName() {
    return this.name;
  }

  public int getMp() {
    return this.mp;
  }

  public void setMp(int mp) {
    this.mp = mp;
  }
  
  String toString() {
    return "スキル:" + name + " 説明：" + subject + "に" + power + "ダメージの" + type;
  }
}
