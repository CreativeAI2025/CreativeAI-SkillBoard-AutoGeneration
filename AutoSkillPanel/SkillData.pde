ArrayList<Skill> nodeSkillData = new ArrayList<>();//スキルをもつノードの情報の保存

void SkillDataSet() {
  for (int i = 0; i < skillData.size(); i++) {
    serchSkillDescription(skillData.get(i));
  }
}

/*contains:ある文字列が別の文字列の中に含まれているかどうかをチェックするメソッド
 返り値はboolean
 match:
 ()は取り出しグループ
 */

void serchSkillDescription(String[] skilldata) {
  String name = skilldata[0];//スキル・ステータスの名前
  String explain = skilldata[1];

  String subject = null;//対象
  String action = null;//行動(攻撃、回復など)
  int power = -1;//効果量
  String type = null;//種類（物理攻撃、特殊攻撃など）
  String status = null;
  String extra = null;//追加効果
  int duration = -1;//持続ターン

  //対象の抽出
  if (explain.contains("相手に")) {
    subject = "相手";
  } else if (explain.contains("味方1人の")|explain.contains("味方1人の")) {
    subject = "味方1人";
  } else if (explain.contains("味方全体の")) {
    subject = "味方全体";
  } else if (explain.contains("自分の")) {
    subject = "自分";
  } else {
    subject = "不明";
  }

  //行動＆種類＆効果量の抽出
  String[] result;
  result = match(explain, "(\\d+)[^0-9]*(物理|特殊)攻撃");
  if (result != null) {
    power = int(result[1]);
    action = "攻撃";
    type = result[2] + "攻撃";
  }

  // 回復
  result = match(explain, "(\\d+)回復");
  if (result != null) {
    power = int(result[1]);
    type = "回復";
  }


  //バフ・デバフ（持続ターン含む）の抽出
  result = match(explain, "(\\d+)ターン");
  if (result != null) {
    duration = int(result[1]);
    if (explain.contains("上昇") || explain.contains("アップ")) {
      type = "バフ";
    } else if (explain.contains("低下") || explain.contains("ダウン")) {
      type = "デバフ";
    }
    
    if (explain.contains("回避率")) {
      status = "回避率";
    }
    if (explain.contains("魔法防御率")) {
      status = "魔法防御";
    }
    if (explain.contains("防御力")) {
      status = "防御力";
    }
  }

  //追加効果の抽出
  if (explain.contains("毒")) type = "毒";
  else if (explain.contains("麻痺")) type = "麻痺";
  else if (explain.contains("睡眠")) type = "睡眠";
  else if (explain.contains("復活")) type = "復活";

  nodeSkillData.add(new Skill(name, subject, action, power, type, status, extra, duration));
}
