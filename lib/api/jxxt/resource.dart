import 'package:hblgdx/model/resource.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

/// 用正则匹配字符串里的所有文件夹信息
List<Resource> getFolders(String content) {
  String regex =
      r'<a href="listview.jsp\?acttype=enter&folderid=(\d+)&lid=(\d+)" title="">(.*?)</a>';
  List<Resource> resources = new List();
  matchAll(regex, content).forEach((match) {
    String folderId = match.group(1);
    String lId = match.group(2);
    String folderName = match.group(3);

    Resource resource = new Resource();
    resource.folderId = folderId;
    resource.lId = lId;
    resource.name = folderName;
    resource.type = ResourceType.folder;

    resources.add(resource);
  });
  return resources;
}

/// 用正则匹配字符串里的所有文件信息
List<Resource> getFiles(String content) {
  String regex =
      r'<a href="preview/download_preview.jsp\?fileid=(\d+)&resid=(\d+)&lid=(\d+)"(?:.|\n)*?>(.*?)</a>';
  List<Resource> resources = new List();
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

    resources.add(resource);
  });
  return resources;
}

/// 获取资源列表
Future<List<Resource>> getResourceList(String courseId,
    [String foldId = '0']) async {
  // 需要先访问这个课程地址才能通过下面的固定地址得到正确的资源信息
  await request.get('$courseUrl?courseId=$courseId');
  String content = await request
      .getContent('$resourceListUrl?lid=$courseId&folderid=$foldId');
  if (content == null) {
    return null;
  }

  List<Resource> resources = new List();
  resources.addAll(getFolders(content));
  resources.addAll(getFiles(content));

  return resources;
}
