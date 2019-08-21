import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hblgdx/api/github/update.dart';
import 'package:hblgdx/api/jwxt/login.dart' deferred as jwxt;
import 'package:hblgdx/api/jxxt/login.dart' deferred as jxxt;
import 'package:hblgdx/model/version.dart';
import 'package:hblgdx/pages/homework_page.dart';
import 'package:hblgdx/pages/resource_page.dart';
import 'package:hblgdx/pages/score_page.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:hblgdx/utils/request.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final String latestReleaseUrl =
      'https://github.com/recallfuture/hblgdx/releases/latest';

  // 懒加载工厂
  List _pageFactory = [
        () => HomeworkPage(),
//        () => CourseTablePage(),
        () => ResourcePage(),
        () => ScorePage(),
  ];

  List<Widget> _pages = [
    Scaffold(),
//    Scaffold(),
    Scaffold(),
    Scaffold(),
  ];

  List<Color> _bottomBarColor = [
    Color.fromARGB(255, 44, 44, 61),
//    Color.fromARGB(255, 61, 61, 111),
    Color.fromARGB(255, 53, 83, 108),
    Color.fromARGB(255, 38, 124, 160),
  ];

  @override
  void initState() {
    super.initState();

    // 懒加载页面
    if (_pages[_currentIndex] is Scaffold) {
      _pages[_currentIndex] = _pageFactory[_currentIndex]();
    }

    _getLatestVersion();
  }

  /// 获取最新的版本号
  _getLatestVersion() async {
    // 没忽略本次更新才去获取新版本
    if (!DataStore.ignoreUpdate) {
      try {
        Version version = await getLatestVersion();
        // 只要版本号不同就提示更新
        if (version.versionName != DataStore.version) {
          _showUpdateDialog(version);
        }
      } catch (e) {
        // 更新错误也没关系，不需要提醒
        print(e.toString());
      }
    }
  }

  _showUpdateDialog(Version version) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('检测到新版本${version.versionName}'),
          content: Text('新版变化：\n${version.changelog}\n\n是否前去下载新版本？'),
          actions: <Widget>[
            MaterialButton(
              child: Text('不再提示'),
              onPressed: () {
                _showToast('如果需要更新，请到关于页面手动检查更新');
                DataStore.setIgnoreUpdate(true);
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('稍后'),
              onPressed: () {
                _showToast('将会在下次打开时再次提醒');
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
                _download(version);
              },
            ),
          ],
        );
      },
    );
  }

  _download(Version version) async {
    try {
      // 获取路径
      String fileName = 'hblgdx.apk';
      Directory dir = await DownloadsPathProvider.downloadsDirectory;
      String path = '${dir.path}/$fileName';

      // 下载
      await request.download(
        version.downloadUrl,
        path,
        onReceiveProgress: (count, total) async {
          int progress = (count / total * 100).floor();
          _showToast('新版本下载进度：$progress%');
        },
      );

      OpenFile.open(path);
    } catch (e) {
      print(e.toString());
      _showToast('下载失败，请手动下载');
      launch(latestReleaseUrl);
    }
  }

  @override
  void dispose() {
    super.dispose();

    // 关闭时注销，防止由于登录人数过多导致的登陆失败
    DataStore.isSignedInJwxt ?? jwxt.logout();
    DataStore.isSignedInJxxt ?? jxxt.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        // 解决灰色头部
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('常见问题'),
            onTap: () => Navigator.of(context).pushNamed('/faq'),
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('问题反馈'),
            onTap: () => Navigator.of(context).pushNamed('/feedback'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于'),
            onTap: () => Navigator.of(context).pushNamed('/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image
              .asset('assets/bg_drawer_header.jpg')
              .image,
        ),
      ),
      child: _buildAccount(
        DataStore.username,
      ),
    );
  }

  /// 帐号
  Widget _buildAccount(String account) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(account),
            ),
            FlatButton(
              color: Colors.red,
              shape: BeveledRectangleBorder(),
              child: Text(
                '注销',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: _showLogOutDialog,
            ),
          ],
        )
      ],
    );
  }

  _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('确定注销么？'),
          content: Text('注销后将需要重新登录才能使用所有功能'),
          actions: <Widget>[
            MaterialButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('确定'),
              onPressed: () async {
                await DataStore.setIsSignedIn(false);
                await DataStore.setScoreReport(null);
                DataStore.isSignedInJxxt = false;
                DataStore.isSignedInJwxt = false;
                DataStore.isSignedInMyncmc = false;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => route == null);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: _bottomBarColor[_currentIndex],
      selectedItemColor: Color.fromARGB(255, 125, 249, 177),
      unselectedItemColor: Colors.white,
      iconSize: 20,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(Image.asset('assets/homework.png').image),
          title: Text('作业'),
        ),
//        BottomNavigationBarItem(
//          icon: ImageIcon(Image.asset('assets/course.png').image),
//          title: Text('课表'),
//        ),
        BottomNavigationBarItem(
          icon: ImageIcon(Image.asset('assets/resource.png').image),
          title: Text('资源'),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(Image.asset('assets/score.png').image),
          title: Text('成绩'),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          if (_pages[_currentIndex] is Scaffold) {
            _pages[_currentIndex] = _pageFactory[_currentIndex]();
          }
        });
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
