import 'package:flutter/material.dart';
import 'package:hblgdx/components/course_table/block_table.dart';

class CourseTablePage extends StatefulWidget {
  @override
  _CourseTablePageState createState() => _CourseTablePageState();
}

class _CourseTablePageState extends State<CourseTablePage> {
  final double blockHeight = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: buildBody(),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('第一学期'),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: Colors.blueGrey,
      type: BottomNavigationBarType.fixed,
      iconSize: 20,
      selectedItemColor: Colors.cyan[100],
      unselectedItemColor: Colors.white,
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
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
      child: BlockTable(),
    );
  }
}
