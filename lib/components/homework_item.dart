import 'package:flutter/material.dart';

class HomeworkItem extends StatelessWidget {
  final String _courseName;
  final String _homeworkTitle;
  final String _endDate;

  HomeworkItem(this._courseName, this._homeworkTitle, this._endDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 15,
            child: Image.asset(
              'assets/lable.png',
              scale: 3,
            ),
          ),
          Container(
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
                          Icon(
                            Icons.info,
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
          )
        ],
      ),
    );
  }
}
