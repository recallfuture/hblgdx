import 'package:flutter/material.dart';
import 'package:hblgdx/api/myncmc/login.dart';
import 'package:hblgdx/api/myncmc/score.dart';
import 'package:hblgdx/model/score.dart';
import 'package:hblgdx/model/score_report.dart';
import 'package:hblgdx/utils/data_store.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  static Future _future;
  static ScoreReport _scoreReport;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();

    if (_future == null) {
      _future = _getScoreReport();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _future = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image
              .asset('assets/bg_score.jpg')
              .image,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('成绩查询'),
          centerTitle: true,
//          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _future = _getScoreReport(),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Text(
                        _loadingText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              case ConnectionState.done:
                return _buildScoreReport();
            }
            return null;
          },
        ),
      ),
    );
  }

  /// 渲染成绩查询
  Widget _buildScoreReport() {
    // 出现错误
    if (_scoreReport == null) {
      return Card(
        color: Colors.red,
        child: Container(
          height: 120,
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              Text(
                '出错啦!',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '错误原因：$_errorText',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    List<Score> scores = _scoreReport.scores;

    // 正常渲染
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('姓名：${_scoreReport.name}'),
                  Text('学号：${_scoreReport.number}'),
                  Text('系所：${_scoreReport.departmentName}'),
                  Text('班级：${_scoreReport.className}'),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: List<Widget>.generate(scores.length, (index) {
                  return ListTile(
                    title: Text(scores[index].name),
                    leading: CircleAvatar(
                      backgroundColor:
                      scores[index].score >= 60 ? Colors.green : Colors.red,
                      child: Text(
                        scores[index].score.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getScoreReport() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    try {
      // 登录
      if (!DataStore.isSignedInMyncmc) {
        _setLoadingText('登录中');
        int code = await login(DataStore.username, DataStore.jwxtPassword);
        if (code != 200) {
          throw Exception('登录错误，错误码$code');
        }
        DataStore.isSignedInMyncmc = true;
      }

      // 获取成绩分析单
      _setLoadingText('获取成绩单中');
      String json = await getScoreJson();
      print(json);
      _scoreReport = getScoreReport(json);
    } catch (e) {
      // 错误处理
      print(e.toString());
      _setErrorText(e.toString());
      _scoreReport = null;
    } finally {
      // 更新
      setState(() {
        _scoreReport = _scoreReport;
      });
      _isLoading = false;
    }
  }

  _setLoadingText(String text) {
    setState(() {
      _loadingText = text;
    });
  }

  _setErrorText(String text) {
    setState(() {
      _errorText = text;
    });
  }
}
