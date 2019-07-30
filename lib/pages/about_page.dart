import 'package:flutter/material.dart';
import 'package:hblgdx/api/github/update.dart';
import 'package:hblgdx/model/version.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutItem {
  final String title;
  final String content;
  final onTap;

  AboutItem(this.title, this.content, [this.onTap]);
}

class AboutPage extends StatelessWidget {
  final BuildContext _context;
  final String latestReleaseUrl =
      'https://github.com/recallfuture/hblgdx/releases/latest';

  final List<AboutItem> _aboutItems = [
    AboutItem('校园查', '校园查是由两个人制做的华北理工大学综合查询APP'),
    AboutItem(
      '程序猿',
      'SU<recallsufuture@gmail.com>',
          () => launch('mailto:recallsufuture@gmail.com'),
    ),
    AboutItem(
      '设计狮',
      '老柯<2092379934@qq.com>',
          () => launch('mailto:2092379934@qq.com'),
    ),
    AboutItem(
      '项目源码',
      'https://github.com/recallfuture/hblgdx',
          () => launch('https://github.com/recallfuture/hblgdx'),
    ),
    AboutItem(
      '最新版本',
      'https://github.com/recallfuture/hblgdx/releases/latest',
          () =>
          launch('https://github.com/recallfuture/hblgdx/releases/latest'),
    ),
    AboutItem('开源协议', 'MIT'),
    AboutItem('版本号', DataStore.version),
  ];

  AboutPage(this._context) {
    // 只能在这里添加带有方法的
    _aboutItems.add(AboutItem('检查更新', null, _getLatestVersion));
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('关于'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pink,
      ),
      body: _buildAboutList(),
    );
  }

  Widget _buildAboutList() {
    Iterable<Widget> tiles = _aboutItems.map(
          (item) =>
          ListTile(
        title: Text(item.title),
        subtitle: item.content == null ? null : Text(item.content),
        onTap: item.onTap,
      ),
    );

    return ListView(
      children: ListTile.divideTiles(
        tiles: tiles,
        color: Colors.grey,
      ).toList(),
    );
  }

  /// 获取最新的版本号
  _getLatestVersion() async {
    try {
      _showToast('开始检查更新');
      DataStore.setIgnoreUpdate(false);
      Version version = await getLatestVersion();
      // 只要版本号不同就提示更新
      if (version.versionName != DataStore.version) {
        _showUpdateDialog(version);
      } else {
        _showToast('已经是最新版');
      }
    } catch (e) {
      print(e.toString());
      _showToast('获取更新失败');
    }
  }

  _showUpdateDialog(Version version) {
    showDialog(
      context: _context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('检测到新版本${version.versionName}'),
          content: Text('新版变化：\n${version.changelog}\n\n是否前去下载新版本？'),
          actions: <Widget>[
            MaterialButton(
              child: Text('稍后'),
              onPressed: () {
                _showToast('将会在下次打开时再次提醒');
                Navigator.pop(_context);
              },
            ),
            MaterialButton(
              child: Text('确定'),
              onPressed: () {
                _showToast('正在跳转到下载地址');
                Navigator.pop(_context);
                launch(latestReleaseUrl);
              },
            ),
          ],
        );
      },
    );
  }

  _showToast(String msg) {
    showToast(
      msg,
      duration: Duration(seconds: 2),
      position: ToastPosition.top,
      backgroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.black),
    );
  }
}
