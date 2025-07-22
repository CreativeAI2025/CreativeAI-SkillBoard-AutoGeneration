HashMap<Integer, float[]> nodePerData = new HashMap<>();//ノードの出現確率
HashMap<Integer, float[]> linelimitPerRow = new HashMap<>();//遷移による枝数の制限
HashMap<String, float[]> skill_or_statusPerRow = new HashMap<>();//スキル・ステータスの変移確率(スキル、ステータス、初期状態)
HashMap<Integer, String[]> skillData = new HashMap<>();// スキル名とスキルの説明のデータ

void DataSet() {
  NodePerData();
  SkillData();
}

void NodePerData() {
  nodePerData.put(0, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(1, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(2, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(3, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(4, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(5, new float[]{0.2, 0.2, 0.2, 0.2, 0.2, 0.2});
  nodePerData.put(6, new float[]{0.5, 0.5, 0, 0, 0, 0});//初期状態
}

void SkillOrStatusData() {//入力に対して次がスキルまたステータスの確率(スキル、ステータス、初期状態)
  skill_or_statusPerRow.put("スキル", new float[]{0.518, 0.482});
  skill_or_statusPerRow.put("ステータス", new float[]{0.435, 0.565});
  skill_or_statusPerRow.put("初期状態", new float[]{0.857, 0.143});//初期状態
}

void SkillData() {//ユーザが触るのはここだけ
  skillData.put(0, new String[]{"エターナルブリザード", "相手に150ダメージの特殊攻撃"});
  skillData.put(1, new String[]{"めちゃつよパンチ", "相手に200ダメージの物理攻撃"});
  skillData.put(2, new String[]{"ヒールライト", "味方1人のHPを50回復する魔法"});
  skillData.put(3, new String[]{"サンダーストライク", "相手に180ダメージの特殊攻撃"});
  skillData.put(4, new String[]{"ファイアボール", "相手に120ダメージの特殊攻撃"});
  skillData.put(5, new String[]{"アイスシールド", "味方全体の防御力を2ターン上昇させる"});
  skillData.put(6, new String[]{"ポイズンニードル", "相手を3ターンの間毒状態にする"});
  skillData.put(7, new String[]{"ブレイブスラッシュ", "相手に160ダメージの物理攻撃"});
  skillData.put(8, new String[]{"マジックバリア", "味方全体の魔法防御力を3ターン上昇させる"});
  skillData.put(9, new String[]{"リザレクション", "味方1人をHP30%で復活させる"});
  skillData.put(10, new String[]{"シャドウステップ", "自分の回避率を2ターン上昇させる"});
  skillData.put(11, new String[]{"ギガインパクト", "相手に300ダメージの物理攻撃"});
  skillData.put(12, new String[]{"ウィンドカッター", "相手に130ダメージの特殊攻撃"});
}
