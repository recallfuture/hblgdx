import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedBackPage extends StatelessWidget {
  final String _githubIssuesUrl =
      'https://github.com/recallfuture/hblgdx/issues';
  final String _mailUrl = 'mailto:1498881550@qq.com?subject=问题反馈';

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('问题反馈'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: _buildFeedback(),
      ),
    );
  }

  Widget _buildFeedback() {
    return ListView(
      children: <Widget>[
        _buildEmail(),
        _buildGithub(),
        _buildTip(),
      ],
    );
  }

  Widget _buildGithub() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '在Github上提交Issue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '在本项目的Issues中提出问题或是希望添加的新功能，如果能顺便给个star那就更好了',
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              child: Text('去反馈'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () => launch(_githubIssuesUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Card(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '向我发送反馈邮件',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '邮箱地址：1498881550@qq.com',
              textAlign: TextAlign.center,
            ),
            Text(
              '也可以直接点击下面的按钮开始编写邮件',
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              child: Text('去反馈'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () => launch(_mailUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 50),
        Text('请在反馈时将遇到的问题描述详细，最好配上截图'),
        Text('感谢每一位反馈者为这个项目作出的贡献'),
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 24,
        ),
      ],
    );
  }
}
