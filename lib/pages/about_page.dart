import 'package:flutter/material.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutItem {
  final String title;
  final String content;
  final onTap;

  AboutItem(this.title, this.content, [this.onTap]);
}

class AboutPage extends StatelessWidget {
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
      () => launch('https://github.com/recallfuture/hblgdx/releases/latest'),
    ),
    AboutItem('开源协议', 'MIT'),
    AboutItem('版本号', DataStore.version),
    AboutItem('检查更新', null, () {}),
  ];

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
      (item) => ListTile(
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
}
