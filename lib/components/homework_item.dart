import 'package:flutter/material.dart';

class HomeworkItem extends StatelessWidget {
  final bool finished;
  final String _courseName;
  final String _homeworkTitle;
  final String _endDate;
  final onTap;

  HomeworkItem(this._courseName, this._homeworkTitle, this._endDate,
      {@required this.onTap, this.finished = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Stack(
            children: <Widget>[
              buildLabelImage(),
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabelImage() {
    return Positioned(
      top: 0,
      right: 15,
      child: Image.asset(
        'assets/label.png',
        scale: 3,
      ),
    );
  }

  Widget buildContent() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    finished
                        ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 22,
                    )
                        : Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 22,
                    ),
                    SizedBox(width: 5),
                    Text(_courseName, style: TextStyle(fontSize: 20)),
                  ],
                ),
                Text(
                  _homeworkTitle,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                Text(
                  '提交日期：$_endDate',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
