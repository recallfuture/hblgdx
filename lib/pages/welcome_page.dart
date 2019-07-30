import 'package:flutter/material.dart';
import 'package:hblgdx/utils/data_store.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  PageController _controller;
  int _currentIndex = 0;
  final List<String> _pictureList = [
    'assets/bg_homework.jpg',
    'assets/bg_score.jpg',
    'assets/bg_homework.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildPageView(),
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _controller,
      itemCount: _pictureList.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        Widget child;
        if (index == _pictureList.length - 1) {
          child = Center(
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                await DataStore.setIsFirstTime(false);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => route == null,
                );
              },
              child: Text('开始使用'),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(_pictureList[index]).image,
            ),
          ),
          child: child,
        );
      },
    );
  }

  _onPageChanged(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 指示器
  Widget _buildIndicator() {
    return Positioned(
      bottom: 20,
      child: Row(
        children: List.generate(
          _pictureList.length,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: index == _currentIndex ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
