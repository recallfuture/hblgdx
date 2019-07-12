import 'package:hblgdx/utils/regex.dart';

class Homework {
  /// 作业id
  String id;

  /// 作业标题
  String title;

  /// 作业截至日期
  DateTime dateTime;

  /// 作业成绩
  int score;

  /// 作业发布人
  String publisher;

  /// 作业统计链接
  String countUrl;

  /// 做作业链接
  String submitUrl;

  /// 作业结果链接
  String resultUrl;

  /// 从一列数据中获取homework对象
  static Homework fromMatchList(List<Match> cols) {
    Homework result = new Homework();

    for (int i = 0; i < cols.length; i++) {
      String content = cols[i].group(1);

      switch (i) {
        case 0:
          result.title = _getHomeworkTitle(content);
          break;
        case 1:
          result.dateTime = _getHomeworkDate(content);
          break;
        case 2:
          result.score = _getHomeworkScore(content);
          break;
        case 3:
          result.publisher = _getHomeworkPublisher(content);
          break;
        case 4:
          result.countUrl = _getHomeworkCount(content);
          break;
        case 5:
          result.submitUrl = _getHomeworkSubmit(content);
          break;
        case 6:
          result.resultUrl = _getHomeworkResult(content);
          break;
      }
    }

    // 获取id
    result.id = _getHomeworkId(result.countUrl);

    // 返回homework
    return result;
  }

  /// 获取作业名
  static String _getHomeworkTitle(String content) {
    // 匹配作业名
    Match m = matchOne(r'<a.*?>(\S+)(?:.|\n)*?</a>', content);
    return m != null ? m.group(1) : null;
  }

  /// 获取作业截至日期
  static DateTime _getHomeworkDate(String content) {
    // 匹配日期
    Iterable<Match> ms = matchAll(r'(\d+)', content);
    var ml = ms.toList();
    if (ml.length > 0) {
      int year = int.parse(ml[0].group(1));
      int month = int.parse(ml[1].group(1));
      int day = int.parse(ml[2].group(1));
      return DateTime(year, month, day);
    } else {
      return null;
    }
  }

  /// 获取作业得分
  static int _getHomeworkScore(String content) {
    // 匹配分数
    Match m = matchOne(r'(\d+)', content);
    return m != null ? int.parse(m.group(1)) : null;
  }

  /// 获取发布人姓名
  static String _getHomeworkPublisher(String content) {
    // 匹配发布人
    Match m = matchOne(r'(\S+)', content);
    return m != null ? m.group(1) : null;
  }

  /// 获取统计信息链接
  static String _getHomeworkCount(String content) {
    // 匹配统计信息
    Match m = matchOne(r'href="../(.+?)"', content);
    return m != null ? 'common/hw/${m.group(1)}' : null;
  }

  /// 获取提交作业按钮的链接
  static String _getHomeworkSubmit(String content) {
    // 匹配提交作业
    Match m = matchOne(r'href="(.+?)"', content);
    return m != null ? 'common/hw/student/${m.group(1)}' : null;
  }

  /// 获取查看结果的链接
  static String _getHomeworkResult(String content) {
    // 匹配查看结果
    Match m = matchOne(r'href="(.+?)"', content);
    return m != null ? 'common/hw/student/${m.group(1)}' : null;
  }

  /// 从统计信息url中获得作业id
  static String _getHomeworkId(String countUrl) {
    return matchOne(r'hwtid=(\d+)', countUrl)?.group(1);
  }
}
