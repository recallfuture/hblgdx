import 'package:flutter/material.dart';
import 'package:hblgdx/pages/course_table_page.dart';
import 'package:hblgdx/pages/homework_page.dart';
import 'package:hblgdx/pages/resource_page.dart';
import 'package:hblgdx/pages/score_page.dart';
import 'package:hblgdx/utils/data_store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 懒加载工厂
  List _pageFactory = [
        () => HomeworkPage(),
        () => CourseTablePage(),
        () => ResourcePage(),
        () => ScorePage(),
  ];

  List<Widget> _pages = [
    Scaffold(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
  ];

  List<Color> _bottomBarColor = [
    Color.fromARGB(255, 44, 44, 61),
    Color.fromARGB(255, 61, 61, 111),
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
      child: _buildAccount(
        DataStore.username,
      ),
    );
  }

  /// 帐号
  Widget _buildAccount(String account) {
    return Column(
      children: <Widget>[
        Text('欢迎', style: TextStyle(fontSize: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(account),
            FlatButton(
              child: Text(
                '注销',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
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
          if (_pages[_currentIndex] is Scaffold) {
            _pages[_currentIndex] = _pageFactory[_currentIndex]();
          }
        });
      },
    );
  }
}
