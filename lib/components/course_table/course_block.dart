import 'package:flutter/material.dart';
import 'package:hblgdx/model/course_table/course.dart';

class CourseBlock extends StatelessWidget {
  final Course course;
  final Color backgroundColor;
  final Color textColor;
  final int size;
  final double height;
  final onTap;

  CourseBlock(this.course, {
    this.backgroundColor = Colors.black12,
    this.textColor = Colors.grey,
    this.size = 1,
    this.height = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * size,
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          '${course.name}@${course.teacher}',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
