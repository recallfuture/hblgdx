import 'package:hblgdx/model/homework.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

/// 获取由课程号和课程名组成的map
///
/// 需要登录后访问
Future<Map<String, String>> getCourseMap() async {
  Map<String, String> result = new Map();

  String content = await request.getContent(courseListUrl);
  if (content == null) {
    return null;
  }

  String regex =
      r'<a href="./lesson/enter_course.jsp\?lid=(\d+)&t=hw" target="_blank">(.+?)</a></li>';
  // 获取结果集并放入map
  matchAll(regex, content).forEach((m) {
    String courseId = m.group(1).trim();
    String courseName = m.group(2).trim();
    result[courseId] = courseName;
  });

  return result;
}

/// 获取单门课程的作业信息
///
/// 登录后访问
///
/// 返回这门课程的作业列表
Future<List<Homework>> getHomeworkList(String courseId) async {
  List<Homework> result = new List();

  // 需要先访问这个课程地址才能通过下面的固定地址得到正确的作业信息
  await request.get(courseUrl + courseId);
  String content = await request.getContent(homeworkListUrl);
  if (content == null) {
    return null;
  }

  // 获取表格的所有行并遍历
  matchAll(r'<tr>((?:.|\n)*?)</tr>', content).forEach((row) {
    String regex = r'<td.*?>((?:.|\n)*?)</td>';
    Homework homework;

    // 获取表格的所有列并整理成Homework对象
    homework = Homework.fromMatchList(matchAll(regex, row.group(1)).toList());
    result.add(homework);
  });

  return result;
}

/// 获取作业详情信息
Future<String> getHomeworkDetail(String homeworkId) async {
  String content = await request.getContent(homeworkDetailUrl + homeworkId);
  String regex = r"<input type='hidden'.*?value='(.*?)'>";
  Match match = matchOne(regex, content);
  if (match != null) {
    String html = match.group(1);
    html = html.replaceAll(RegExp(r'&lt;'), '<');
    html = html.replaceAll(RegExp(r'&gt;'), '>');
    html = html.replaceAll(RegExp(r'&quot;'), '"');
    html = html.replaceAll(RegExp(r'&amp;'), '&');
    return html;
  }

  return null;
}
