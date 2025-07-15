HashMap<Integer, Integer> nodelimitPerRow = new HashMap<>();//階層によるノード数の制限
HashMap<Integer, float[]> linelimitPerRow = new HashMap<>();//遷移による枝数の制限
HashMap<String, float[]> skill_or_statusPerRow = new HashMap<>();//スキル・ステータスの変移確率(スキル、ステータス、初期状態)
HashMap<Integer, String[]> skillData = new HashMap<>();// スキル名とスキルの説明のデータ
HashMap<String, String[]> statusData = new HashMap<>();// ステータス名とステータスの説明のデータ

void DataSet() {
  NodeLimitData();
  lineLimitData();
  SkillOrStatusData();
  SkillData();
  StatusData();
}

void NodeLimitData() {//各階層でノードの個数の制限
  rows = 11;
  nodelimitPerRow.put(0, 1);
  nodelimitPerRow.put(1, 2);
  nodelimitPerRow.put(2, 4);
  nodelimitPerRow.put(3, 2);
  nodelimitPerRow.put(4, 7);
  nodelimitPerRow.put(5, 5);
  nodelimitPerRow.put(6, 7);
  nodelimitPerRow.put(7, 3);
  nodelimitPerRow.put(8, 1);
  nodelimitPerRow.put(9, 2);
  nodelimitPerRow.put(10, 1);
}

void lineLimitData() {//階層のノード数に対して枝数の確率(最高枝数６)
  // 階層のノード数が2個のとき → 枝1: 50%, 枝2: 30%, 枝3: 20%
  linelimitPerRow.put(0, new float[]{0, 0, 0, 0, 0, 0, 0});
  linelimitPerRow.put(1, new float[]{0, 0, 0, 0, 1, 0.000, 0.00});
  linelimitPerRow.put(2, new float[]{0, 0.05, 0.05, 0, 0, 0, 0.9});
  linelimitPerRow.put(3, new float[]{0, 0, 0, 0, 1, 0, 0});
  linelimitPerRow.put(4, new float[]{0, 0, 1, 0, 0, 0.000, 0.000});
  linelimitPerRow.put(5, new float[]{0, 0, 0, 0.6, 0, 0, 0.4});
  linelimitPerRow.put(6, new float[]{0, 0, 0, 0, 0.000, 0.000, 0.000});
  linelimitPerRow.put(7, new float[]{0, 0, 1, 0, 0.000, 0.000, 0.000});
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
  skillData.put(6, new String[]{"ポイズンニードル", "相手に50ダメージ＋毒状態にする"});
  skillData.put(7, new String[]{"ブレイブスラッシュ", "相手に160ダメージの物理攻撃"});
  skillData.put(8, new String[]{"マジックバリア", "味方全体の魔法防御力を3ターン上昇させる"});
  skillData.put(9, new String[]{"リザレクション", "味方1人をHP30%で復活させる"});
  skillData.put(10, new String[]{"シャドウステップ", "自分の回避率を2ターン上昇させる"});
  skillData.put(11, new String[]{"ギガインパクト", "相手に300ダメージの大技。次ターン行動不可"});
  skillData.put(12, new String[]{"ウィンドカッター", "相手に130ダメージの特殊攻撃"});
}

void StatusData() {
  statusData.put("ステータス", new String[]{"攻撃力アップ", "攻撃力が5%上昇"});
}
