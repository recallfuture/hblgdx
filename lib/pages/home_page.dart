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

  List<Widget> _pages = [
    HomeworkPage(),
    CourseTablePage(),
    ResourcePage(),
    ScorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: _pages[_currentIndex],
    );
  }

  Widget buildBottomNavigationBar() {
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
