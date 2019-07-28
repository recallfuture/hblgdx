import 'package:hblgdx/api/jxxt/base.dart';

/// 资源类型
enum ResourceType {
  folder,
  file,
}

/// 资源类
class Resource {
  /// 文件的id
  String fileId;

  /// 文件夹的id
  String folderId;

  /// 文件的资源id
  String resId;

  /// 课程id
  String lId;

  /// 资源的名字
  String name;

  /// 文件真正的名字
  String realName;

  /// 资源的类型（文件或文件夹）
  ResourceType type;

  /// 获取下载链接
  /// 只允许下载文件
  String get downloadUrl {
    if (type == ResourceType.folder) {
      return null;
    }

    return '$resourceDownloadUrl?fileid=$fileId&resid=$resId&lid=$lId';
  }

  String toString() {
    return 'fileId=$fileId\n'
        'resId=$resId\n'
        'lid=$lId\n'
        'folderId=$folderId'
        'name=$name\n'
        'type=${type == ResourceType.folder ? 'folder' : 'file'}';
  }
}
