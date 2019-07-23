import 'package:flutter/material.dart';
import 'package:hblgdx/pages/course_table_page.dart';
import 'package:hblgdx/pages/homework_page.dart';
import 'package:hblgdx/pages/resource_page.dart';
import 'package:hblgdx/pages/score_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  List<Widget> _pages = [
    HomeworkPage(),
    CourseTablePage(),
    ResourcePage(),
    ScorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: _pages[_currentIndex],
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
            leading: Icon(Icons.folder),
            title: Text('我的文件'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('下载设置'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于我们'),
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
              .asset('assets/drawer_image.png')
              .image,
          colorFilter: ColorFilter.mode(
              Colors.blue[50].withAlpha(200), BlendMode.lighten),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAccount(
            '教学：',
            '201643710101',
            onPressed: _showUnbindJxAccountDialog,
          ),
          _buildAccount(
            '教务：',
            '201643710101',
            onPressed: _showUnbindJwAccountDialog,
          ),
        ],
      ),
    );
  }

  /// 帐号
  Widget _buildAccount(String title, String account, {onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: _boldStyle,
        ),
        Text(account),
        FlatButton(
          child: Text(
            '解绑',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  _showUnbindJwAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('确定解绑么？'),
          content: Text('解绑后将无法使用查成绩功能'),
          actions: <Widget>[
            MaterialButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _showUnbindJxAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('确定解绑么？'),
          content: Text('解绑后将无法使用查作业，资源等功能'),
          actions: <Widget>[
            MaterialButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey,
      selectedItemColor: Colors.cyan[100],
      unselectedItemColor: Colors.white,
      iconSize: 20,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(Image.asset('assets/homework.png').image),
          title: Text('作业'),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(Image.asset('assets/course.png').image),
          title: Text('课表'),
        ),
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
        });
      },
    );
  }
}
