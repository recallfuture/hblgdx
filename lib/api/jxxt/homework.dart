import 'package:hblgdx/model/jxxt/course.dart';
import 'package:hblgdx/model/jxxt/homework.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'base.dart';

/// 获取待交作业的课程信息
///
/// 需要登录后访问
/// 返回由课程号和课程名组成的map
Future<List<Course>> getReminderList() async {
  List<Course> result = new List();

  String content = await request.getContent(reminderListUrl);
  if (content == null) {
    return null;
  }

  String regex =
      r'<a href="./lesson/enter_course.jsp\?lid=(\d+)&t=hw" target="_blank">(.+?)</a></li>';
  // 获取结果集并放入map
  matchAll(regex, content).forEach((m) {
    String courseId = m.group(1).trim();
    String courseName = m.group(2).trim();

    Course course = new Course(courseId, courseName);

    result.add(course);
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
  await request.get('$courseUrl?courseId=$courseId');
  String content = await request.getContent(homeworkListUrl);
  if (content == null) {
    return null;
  }

  var document = parse(content);
  var trList = document.getElementsByTagName('tr');
  // i=0时获取的是th头信息，需要跳过
  for (int i = 1; i < trList.length; i++) {
    var tdList = trList[i].getElementsByTagName('td');
    result.add(_getHomeworkFromTdList(tdList));
  }

  return result;
}

/// 获取作业详情信息
///
/// 登录后访问
Future<String> getHomeworkDetail(String homeworkId) async {
  String regex = r"<input type='hidden'.*?value='(.*?)'>";
  String content =
  await request.getContent('$homeworkDetailUrl?hwtid=$homeworkId');
  if (content == null) {
    return null;
  }

  var document = parse(content);
  var input = document.querySelector('input[type=hidden]');

  if (input != null) {
    String html = input.attributes['value'];
    html = html.replaceAll(RegExp(r'&lt;'), '<');
    html = html.replaceAll(RegExp(r'&gt;'), '>');
    html = html.replaceAll(RegExp(r'&quot;'), '"');
    html = html.replaceAll(RegExp(r'&amp;'), '&');
    return html;
  }

  return null;
}

/// 从td节点列表中获取作业信息
_getHomeworkFromTdList(List<Element> list) {
  Homework result = new Homework();

  for (int i = 0; i < list.length; i++) {
    var td = list[i];

    switch (i) {
      case 0:
        result.title = td
            .querySelector('a')
            .innerHtml
            .trim();
        break;
      case 1:
        result.dateTime = td.innerHtml.trim();
        break;
      case 2:
        result.score = td.innerHtml.trim();
        break;
      case 3:
        result.publisher = td.innerHtml.trim();
        break;
      case 4:
        result.countUrl = _getUrlFromTd(td);
        break;
      case 5:
        result.submitUrl = _getUrlFromTd(td);
        break;
      case 6:
        result.resultUrl = _getUrlFromTd(td);
        break;
    }
  }

  result.id = _getHomeworkId(result.countUrl);
  return result;
}

/// 从td中获取url
String _getUrlFromTd(Element td) {
  var attributes = td
      .querySelector('a')
      ?.attributes;
  return attributes == null ? null : homeworkListUrl + attributes['href'];
}

/// 从统计信息url中获得作业id
String _getHomeworkId(String countUrl) {
  return matchOne(r'hwtid=(\d+)', countUrl)?.group(1);
}
