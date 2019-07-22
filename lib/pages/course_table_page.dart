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
      title: Text('第一学期'),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
      child: BlockTable(),
    );
  }
}
