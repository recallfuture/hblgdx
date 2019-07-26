import 'package:flutter/material.dart';
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
  Future _future;
  static List<Homework> _homeworkList;
  String loadingText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _getHomeworkList();
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
                        loadingText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              case ConnectionState.done:
                return _buildHomeworkList();
            }
            return null;
          },
        ),
      ),
    );
  }

  /// 渲染作业列表
  Widget _buildHomeworkList() {
    // 出现错误
    if (_homeworkList == null) {
      return Container(
        height: 120,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
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
              '错误原因：$loadingText',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    // 无待交作业
    if (_homeworkList.length == 0) {
      return Container(
        height: 120,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
        ),
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
      );
    }

    // 有作业
    return Container(
      child: ListView(
        children: List<Widget>.generate(_homeworkList.length, (index) {
          Homework homework = _homeworkList[index];
          return HomeworkItem(
              homework.course.name, homework.title, homework.dateTime);
        }),
      ),
    );
  }

  /// 获取完整的homework列表
  Future _getHomeworkList() async {
    if (_homeworkList != null) {
      return;
    }
    _homeworkList = new List();

    try {
      // 登录
      if (!DataStore.isSignedInJxxt) {
        loadingText = '登录中';
        int code = await login(DataStore.username, DataStore.jxxtPassword);
        if (code != 200) {
          throw Error();
        }
        DataStore.isSignedInJxxt = true;
      }

      // 获取课程信息
      loadingText = '获取课程信息';
      var courses = await getReminderList();
//      var courses = await getAllCourses();
      if (courses == null) {
        _homeworkList = null;
        throw Error();
      }

      // 获取作业信息
      loadingText = '获取作业信息';
      for (int i = 0; i < courses.length; i++) {
        var list = await getHomeworkList(courses[i].id);
        list.forEach((homework) => homework.course = courses[i]);
        _homeworkList.addAll(list);
      }
    } catch (e) {
      print(e.toString());
      loadingText = e.toString();
      _homeworkList = null;
    } finally {
      // 更新
      setState(() {
        _homeworkList = _homeworkList;
      });
    }
  }
}
