import 'package:hblgdx/model/jxxt/course.dart';

class Homework {
  /// 作业id
  String id;

  /// 作业标题
  String title;

  /// 作业截至日期
  String dateTime;

  /// 作业成绩
  String score;

  /// 作业发布人
  String publisher;

  /// 作业统计链接
  String countUrl;

  /// 做作业链接
  String submitUrl;

  /// 作业结果链接
  String resultUrl;

  /// 所属的课程
  Course course;

  /// 作业详情
  String detail;

  String toString() {
    return 'id=$id\n'
        'title=$title\n'
        'datetime=$dateTime\n'
        'score=$score\n'
        'publisher=$publisher\n'
        'countUrl=$countUrl\n'
        'submitUrl=$submitUrl\n'
        'resultUrl=$resultUrl';
  }
}
