import 'package:flutter/material.dart';

class WeekBar extends StatelessWidget {
  final Color color;
  final DateTime now;
  final double height;

  WeekBar(this.now, {this.color = Colors.white, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: color,
        child: Row(
          children: <Widget>[
            buildMonth(),
            buildWeek(1),
            buildWeek(2),
            buildWeek(3),
            buildWeek(4),
            buildWeek(5),
            buildWeek(6),
            buildWeek(7),
          ],
        ),
      ),
    );
  }

  Widget buildMonth() {
    return Container(
      width: 30,
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${now.month}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              '月',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  final weekText = [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  Widget buildWeek(int weekDay) {
    DateTime dateTime = now.add(Duration(days: -now.weekday + weekDay));
    int month = dateTime.month;
    int day = dateTime.day;

    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              weekText[weekDay - 1],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              '$month/$day',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      flex: 1,
    );
  }
}
