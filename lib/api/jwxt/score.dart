import 'package:hblgdx/model/jwxt/grade.dart';
import 'package:hblgdx/model/jwxt/score.dart';
import 'package:hblgdx/model/jwxt/scoreTable.dart';
import 'package:hblgdx/model/jxxt/course.dart';
import 'package:hblgdx/utils/request.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'base.dart';

/// 获取学年列表
Future<List<Grade>> getGradeList() async {
  String content = await request.getContent(jgScoreUrl);
  return _getGradeList(content);
}

/// 获取制定学年的所有成绩表
Future<List<ScoreTable>> getScoreTableList(String scoreTableUrl) async {
  String html = await request.getContent(scoreTableUrl);
  return _getScoreTableList(html);
}

/// 获取学年列表
List<Grade> _getGradeList(String html) {
  List<Grade> result = new List();

  var document = parse(html);
  document.querySelectorAll('a[target=lnqbIfra]').forEach((a) {
    String url = baseUrl + a.attributes['href'];
    String description = a.innerHtml.trim();

    Grade grade = new Grade(description, url);

    result.add(grade);
  });

  return result;
}

/// 获取单个成绩表
ScoreTable _getScoreTable(Element element) {
  List<Score> scores = new List();

  element.getElementsByClassName('odd').forEach((tr) {
    var tdList = tr.getElementsByTagName('td').toList();

    String courseId = tdList[0].innerHtml.trim();
    String courseName = tdList[2].innerHtml.trim();
    // 学分
    // String credit = tdList[4].innerHtml.trim();
    String scoreString = tdList[6]
        .querySelector('p')
        .innerHtml
        .replaceFirst(RegExp(r'&nbsp;'), '');

    Course course = new Course(courseId, courseName);
    Score score = new Score(course, scoreString);

    scores.add(score);
  });

  return new ScoreTable(scores);
}

/// 获取所有成绩表
List<ScoreTable> _getScoreTableList(String html) {
  List<ScoreTable> result = new List();

  var document = parse(html);
  document.getElementsByClassName('displayTag').forEach((element) {
    ScoreTable scoreTable = _getScoreTable(element);
    result.add(scoreTable);
  });

  return result;
}
