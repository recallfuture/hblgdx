import 'package:flutter/material.dart';

class CourseBlock extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final int size;
  final double height;

  CourseBlock(this.title,
      {this.backgroundColor = Colors.black12,
      this.textColor = Colors.grey,
      this.size = 1,
      this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * size,
      margin: EdgeInsets.all(1),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        title,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
