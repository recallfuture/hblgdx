import 'package:flutter/material.dart';

class WhiteBlock extends StatelessWidget {
  final double height;

  WhiteBlock(this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Container(
//        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
