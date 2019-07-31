import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hblgdx/api/jxxt/homework.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/api/jxxt/resource.dart';
import 'package:hblgdx/components/homework_item.dart';
import 'package:hblgdx/model/jxxt/homework.dart';
import 'package:hblgdx/utils/data_store.dart';

class HomeworkPage extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  Future _future;
  List<Homework> _homeworkList;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();

    _future = _getHomeworkList();
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
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('作业查询'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: _buildFuture(),
    );
  }

  _onRefresh() {
    _future = _getHomeworkList();
  }

  Widget _buildFuture() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildStateNone();
          case ConnectionState.active:
            return _buildStateActive();
          case ConnectionState.waiting:
            return _buildStateWaiting();
          case ConnectionState.done:
            return _buildStateDone();
        }
        return Container();
      },
    );
  }

  Widget _buildStateNone() {
    return Container();
  }

  Widget _buildStateActive() {
    return Container();
  }

  Widget _buildStateWaiting() {
    return Center(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
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
  }

  Widget _buildStateDone() {
    // 出现错误
    if (_homeworkList == null) {
      return _buildErrorCard();
    }

    // 未完成的作业和已完成的作业
    List<Homework> finished =
    _homeworkList.where((homework) => homework.resultUrl != null).toList();
    List<Homework> unfinished =
    _homeworkList.where((homework) => homework.resultUrl == null).toList();

    // 分别生成所有子组件
    List<HomeworkItem> finishedItems = _generateItem(finished, true);
    List<HomeworkItem> unfinishedItems = _generateItem(unfinished, false);

    // 构建待交作业数提示卡片
    Widget tip = Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text('待交作业数：${unfinished.length}'),
      ),
    );

    // 生成组件列表
    List<Widget> childrenList = []
      ..add(tip)
      ..addAll(unfinishedItems)..addAll(finishedItems);

    // 放进列表里显示出来
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: childrenList,
    );
  }

  // 根据作业信息生成组件
  List<HomeworkItem> _generateItem(List<Homework> homeworkList, bool finished) {
    return List<HomeworkItem>.generate(
      homeworkList.length,
          (index) {
        Homework homework = homeworkList[index];
        return HomeworkItem(
          homework.course.name,
          homework.title,
          homework.dateTime,
          onTap: () => _showHomeworkDetail(homework),
          finished: finished,
        );
      },
    );
  }

  Widget _buildErrorCard() {
    // 套上ListView防止高度出界
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        Card(
          color: Colors.red,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ],
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
//      var courses = await getReminderList();
      var courses = await getAllCourses();
      if (courses == null) {
        _homeworkList = null;
        throw Exception('课程获取失败');
      }

      // 获取作业信息
      for (int i = 0; i < courses.length; i++) {
        _setLoadingText('获取${courses[i].name}的作业');
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
