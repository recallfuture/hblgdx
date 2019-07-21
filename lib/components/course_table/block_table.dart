import 'package:flutter/material.dart';
import 'package:hblgdx/components/course_table/course_block.dart';
import 'package:hblgdx/components/course_table/week_bar.dart';
import 'package:hblgdx/components/course_table/white_block.dart';
import 'package:hblgdx/model/course_table/course.dart';

class BlockTable extends StatelessWidget {
  final double blockHeight = 60;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildBlocks(),
        WeekBar(
          DateTime.now(),
          color: Colors.white,
          height: blockHeight,
        ),
      ],
    );
  }

  /// 左边显示节数的列
  Widget buildLeftColumn() {
    return Column(
      children: List<Widget>.generate(
        13,
        (index) => Container(
          width: 30,
          height: blockHeight,
          color: Colors.white,
          child: Center(
            child: Text('${index + 1}'),
          ),
        ),
      ),
    );
  }

  final List<Course> list = [
    Course(
      name: '课程名',
      location: '地点',
      teacher: '教师',
      week: [1, 2, 3, 4, 5, 6, 7, 8],
      weekDay: 1,
      sectionStart: 1,
      sectionEnd: 2,
    ),
    Course(
      name: '课程名',
      location: '地点',
      teacher: '教师',
      week: [1, 2, 3, 4, 5, 6, 7, 8],
      weekDay: 2,
      sectionStart: 3,
      sectionEnd: 4,
    ),
    Course(
      name: '课程名',
      location: '地点',
      teacher: '教师',
      week: [1, 2, 3, 4, 5, 6, 7, 8],
      weekDay: 4,
      sectionStart: 3,
      sectionEnd: 6,
    ),
  ];

  /// 中间的所有列
  List<Widget> buildMainColumns() {
    // 一周7天
    return List<Widget>.generate(7, (index) {
      // 获取当天的课
      Iterable<Course> day = list.where((c) => c.weekDay == index + 1);
      List<Widget> cols = new List();

      // 遍历每天的13节课
      for (int i = 0; i < 13; i++) {
        // 获取课程开始时间等于本节课的课程
        Iterable<Course> courses = day.where((c) => c.sectionStart == i + 1);
        // 没找到就用空块填充
        if (courses.length == 0) {
          cols.add(WhiteBlock(blockHeight));
          continue;
        }

        // 获得其中的第一个课
        Course course = courses.first;
        // 计算块的大小
        int jie = course.sectionEnd - course.sectionStart;
        if (jie >= 0 && jie < 13) {
          cols.add(
            CourseBlock(
              '${course.name}@${course.teacher}',
              size: jie + 1,
              height: blockHeight,
              backgroundColor: Color.fromARGB(255, 250, 107, 91),
              textColor: Colors.white,
            ),
          );
          i += jie;
        } else {
          cols.add(WhiteBlock(blockHeight));
        }
      }

      return Expanded(
        child: Column(
          children: cols,
        ),
      );
    });
  }

  Widget buildBlocks() {
    return Container(
      padding: EdgeInsets.only(top: blockHeight),
      child: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            buildLeftColumn(),
          ]..addAll(buildMainColumns()),
        ),
      ),
    );
  }
}
