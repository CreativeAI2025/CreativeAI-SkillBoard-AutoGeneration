HashMap<Integer, Integer> nodelimitPerRow = new HashMap<>();//階層によるノード数の制限
HashMap<Integer, float[]> linelimitPerRow = new HashMap<>();//遷移による枝数の制限
HashMap<String, float[]> skill_or_statusPerRow = new HashMap<>();//スキル・ステータスの変移確率(スキル、ステータス、初期状態)
HashMap<Integer, String[]> skillData = new HashMap<>();// スキル名とスキルの説明のデータ
HashMap<String, String[]> statusData = new HashMap<>();// ステータス名とステータスの説明のデータ

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
  //nodelimitPerRow.put(11, 1);
  //nodelimitPerRow.put(12, 1);
  //nodelimitPerRow.put(13, 1);
}

void lineLimitData() {//入力枝数に対して出力枝数の確率(最高枝数６)
  // 枝1のとき → 枝1: 50%, 枝2: 30%, 枝3: 20%
  linelimitPerRow.put(0, new float[]{0, 0, 0, 0, 0, 0, 0});
  linelimitPerRow.put(1, new float[]{0.1, 0.000, 0.123, 0.246, 0.140, 0.000, 0.018});
  linelimitPerRow.put(2, new float[]{0, 0.028, 0.008, 0.272, 0.192, 0.016, 0.484});
  linelimitPerRow.put(3, new float[]{0, 0.114, 0.553, 0.000, 0.000, 0.008, 0.325});
  linelimitPerRow.put(4, new float[]{0, 0.095, 0.571, 0.000, 0.333, 0.000, 0.000});
  linelimitPerRow.put(5, new float[]{0, 0, 0.8, 0.2, 0, 0, 0});
  linelimitPerRow.put(6, new float[]{0, 0.006, 0.747, 0.247, 0.000, 0.000, 0.000});
}

void SkillOrStatusData() {//入力に対して次がスキルまたステータスの確率(スキル、ステータス、初期状態)
  skill_or_statusPerRow.put("スキル", new float[]{0.518, 0.482});
  skill_or_statusPerRow.put("ステータス", new float[]{0.435, 0.565});
  skill_or_statusPerRow.put("初期状態", new float[]{0.857, 0.143});//初期状態
}

void SkillData() {//ユーザが触るのはここだけ
  skillData.put(0,new String[]{"エターナルブリザード","相手に150ダメージの物理攻撃"});
}

void StatusData() {
  statusData.put("ステータス",new String[]{"攻撃力アップ","攻撃力が5%上昇"});
}
