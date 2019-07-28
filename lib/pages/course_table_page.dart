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
      body: buildBody(),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('敬请期待'),
      backgroundColor: Color.fromARGB(255, 61, 61, 111),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
      child: BlockTable(),
    );
  }
}
