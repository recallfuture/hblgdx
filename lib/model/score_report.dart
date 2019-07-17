import 'package:json_annotation/json_annotation.dart';

import 'score.dart';

part 'score_report.g.dart';

@JsonSerializable()
class ScoreReport {
  @JsonKey(name: 'xingming')
  String name;

  @JsonKey(name: 'xuehao')
  String number;

  @JsonKey(name: 'xisuo')
  String departmentName;

  @JsonKey(name: 'banji')
  String className;

  List<String> chengji;

  List<Score> scores = new List();

  ScoreReport(this.name, this.number, this.departmentName, this.className,
      this.chengji) {
    _getScores();
  }

  factory ScoreReport.fromJson(Map<String, dynamic> json) =>
      _$ScoreReportFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreReportToJson(this);

  _getScores() {
    int length = chengji.length;
    int scoreNum = length ~/ 6;
    for (int i = 0; i < scoreNum; i++) {
      String name;
      String totalCredit;
      String score;
      String level;
      String credit;
      String type;

      for (int j = 0; j < 6; j++) {
        String value = chengji[i * 6 + j];
        switch (j) {
          case 0:
            name = value;
            break;
          case 1:
            totalCredit = value;
            break;
          case 2:
            score = value;
            break;
          case 3:
            level = value;
            break;
          case 4:
            credit = value;
            break;
          case 5:
            type = value;
            break;
        }
      }

      Score s = new Score(name, totalCredit, score, level, credit, type);
      scores.add(s);
    }
  }
}
