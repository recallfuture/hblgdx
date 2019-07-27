import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hblgdx/api/jxxt/homework.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/components/homework_item.dart';
import 'package:hblgdx/model/homework.dart';
import 'package:hblgdx/utils/data_store.dart';

class HomeworkPage extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  static Future _future;
  static List<Homework> _homeworkList;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();

    if (_future == null) {
      _future = _getHomeworkList();
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
              .asset('assets/bg_homework.jpg')
              .image,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('作业查询'),
          centerTitle: true,
//          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _future = _getHomeworkList(),
            ),
          ],
        ),
        body: _buildFuture(),
      ),
    );
  }

  Widget _buildFuture() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Text(
                        _loadingText,
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            );
          case ConnectionState.done:
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildHomeworkList(),
            );
        }
        return null;
      },
    );
  }

  /// 渲染作业列表
  Widget _buildHomeworkList() {
    // 出现错误
    if (_homeworkList == null) {
      return Card(
        color: Colors.red,
        child: SizedBox(
          height: 120,
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

    // 无待交作业
    if (_homeworkList.length == 0) {
      return Card(
        color: Colors.green,
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              '无待交作业，安心休息吧',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    // 有作业
    return ListView(
      children: List<Widget>.generate(
        _homeworkList.length,
            (index) {
          Homework homework = _homeworkList[index];
          return HomeworkItem(
            homework.course.name,
            homework.title,
            homework.dateTime,
            onTap: () => _showHomeworkDetail(homework),
          );
        },
      ),
    );
  }

  /// 获取完整的homework列表
  Future _getHomeworkList() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _homeworkList = new List();

    try {
      // 登录
      if (!DataStore.isSignedInJxxt) {
        _setLoadingText('登录中');
        int code = await login(DataStore.username, DataStore.jxxtPassword);
        if (code != 200) {
          throw Exception('登录错误，错误码$code');
        }
        DataStore.isSignedInJxxt = true;
      }

      // 获取课程信息
      _setLoadingText('获取课程信息');
      var courses = await getReminderList();
//      var courses = await getAllCourses();
      if (courses == null) {
        _homeworkList = null;
        throw Exception('课程获取失败');
      }

      // 获取作业信息
      _setLoadingText('获取作业信息');
      for (int i = 0; i < courses.length; i++) {
        var list = await getHomeworkList(courses[i].id);
        list.forEach((homework) => homework.course = courses[i]);
        _homeworkList.addAll(list);
      }
    } catch (e) {
      print(e.toString());
      _setErrorText(e.toString());
      _homeworkList = null;
    } finally {
      // 更新
      setState(() {
        _homeworkList = _homeworkList;
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

  void _showHomeworkDetail(Homework homework) async {
    // 没获取就先获取
    if (homework.detail == null) {
      homework.detail = await getHomeworkDetail(homework.id);
    }

    // 显示详细信息的对话框
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(children: <Widget>[
              Text(
                homework.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Html(
                data: homework.detail ?? '读取错误',
                useRichText: true,
                padding: EdgeInsets.all(8.0),
                defaultTextStyle: TextStyle(fontSize: 20.0),
              ),
            ]),
          ),
        );
      },
    );
  }
}
