import 'package:hblgdx/model/course.dart';
import 'package:hblgdx/model/resource.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

/// 获取所有的课程号组成的列表
Future<List<Course>> getAllCourses() async {
  String regex = r'<p class="title">\s+<a.+?courseId=(\d+).+?>\s+(\S+)(?:.|\n)*?</p>';
  String content = await request.getContent(courseListUrl);
  if (content == null) {
    return null;
  }

  List<Course> result = new List();
  matchAll(regex, content).forEach((match) {
    String courseId = match.group(1);
    String courseName = match.group(2);

    Course course = new Course(courseId, courseName);

    result.add(course);
  });

  return result;
}

/// 用正则匹配字符串里的所有文件夹信息
List<Resource> _getFolders(String content) {
  String regex =
      r'<a href="listview.jsp\?acttype=enter&folderid=(\d+)&lid=(\d+)" title="">(.*?)</a>';
  List<Resource> result = new List();
  matchAll(regex, content).forEach((match) {
    String folderId = match.group(1);
    String lId = match.group(2);
    String folderName = match.group(3);

    Resource resource = new Resource();
    resource.folderId = folderId;
    resource.lId = lId;
    resource.name = folderName;
    resource.type = ResourceType.folder;

    result.add(resource);
  });
  return result;
}

/// 用正则匹配字符串里的所有文件信息
List<Resource> _getFiles(String content) {
  String regex =
      r'<a href="preview/download_preview.jsp\?fileid=(\d+)&resid=(\d+)&lid=(\d+)"(?:.|\n)*?>(.*?)</a>';
  List<Resource> result = new List();
  matchAll(regex, content).forEach((match) {
    String fileId = match.group(1);
    String resId = match.group(2);
    String lId = match.group(3);
    String fileName = match.group(4);

    Resource resource = new Resource();
    resource.fileId = fileId;
    resource.resId = resId;
    resource.lId = lId;
    resource.name = fileName;
    resource.type = ResourceType.file;

    result.add(resource);
  });
  return result;
}

/// 获取资源列表
Future<List<Resource>> getResourceList(String courseId,
    [String folderId = '0']) async {
  // 需要先访问这个课程地址才能通过下面的固定地址得到正确的资源信息
  await request.get('$courseUrl?courseId=$courseId');
  String content = await request
      .getContent('$resourceListUrl?lid=$courseId&folderid=$folderId');
  if (content == null) {
    return null;
  }

  List<Resource> result = new List();
  result.addAll(_getFolders(content));
  result.addAll(_getFiles(content));

  return result;
}
