ArrayList<Skill> skillList = new ArrayList<>();

class Skill {
  int id;
  String name;
  String type;
  String category;
  String effect;
  float score;

  Skill(int id, String name, String type, String category, String effect, float score) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.category = category;
    this.effect = effect;
    this.score = score;
  }
}

//csvデータをスキルリストへ
void loadSkillsFromCSV(String path) {
  skillList.clear();
  String[] rows = loadStrings(path);
  for (String row : rows) {
    String[] cols = row.split(",");
    if (cols.length >= 6) { // 列数チェック
      int id = int(cols[0].trim());
      String name = cols[1].trim();
      String type = cols[2].trim();
      String category = cols[3].trim();
      String effect = cols[4].trim();
      float score = float(cols[5].trim());

      skillList.add(new Skill(id, name, type, category, effect, score));
    } else {
      println("CSVの形式が正しくありません：" + row);
    }
  }
}
