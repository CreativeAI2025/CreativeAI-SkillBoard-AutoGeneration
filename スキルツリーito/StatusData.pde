ArrayList<Status> statusList = new ArrayList<>();

class Status {
  int id;
  String name;
  int mp;
  int up;

  Status(int id, String name, int mp, int up) {
    this.id = id;
    this.name = name;
    this.mp = mp;
    this.up = up;
  }
}

//csvデータをステータスリストへ
void loadStatusFromCSV(String path) {
  statusList.clear();
  String[] rows = loadStrings(path);
  for (String row : rows) {
    String[] cols = row.split(",");
    if (cols.length >= 4) { // 安全チェック
      int id = int(cols[0].trim());
      String name = cols[1].trim();
      int mp = int(cols[2].trim());
      int up = int(cols[3].trim());
      statusList.add(new Status(id, name, mp, up));
    } else {
      println("CSVの形式が正しくありません：" + row);
    }
  }
}
