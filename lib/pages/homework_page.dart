import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hblgdx/api/jxxt/homework.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/api/jxxt/resource.dart';
import 'package:hblgdx/components/homework_item.dart';
import 'package:hblgdx/model/jxxt/course.dart';
import 'package:hblgdx/model/jxxt/homework.dart';
import 'package:hblgdx/utils/data_store.dart';

class HomeworkPage extends StatefulWidget {
  final Course course;

  HomeworkPage({this.course});

  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  Future _future;
  List<Course> _reminderCourseList;
  List<Course> _allCourseList;
  List<Homework> _homeworkList;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _onRefresh();
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
        leading: this.widget.course == null
            ? IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )
            : null,
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
    _future = _getData();
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
    if (this.widget.course == null) {
      if (_reminderCourseList == null || _allCourseList == null) {
        return _buildErrorCard();
      }
      return _buildCourseList();
    } else {
      // 出现错误
      if (_homeworkList == null) {
        return _buildErrorCard();
      }
      return _buildHomeworkList();
    }
  }

  Widget _buildCourseList() {
    _allCourseList = _allCourseList.where((course) {
      int count = _reminderCourseList
          .where((e) => e.id == course.id)
          .length;
      return count == 0;
    }).toList();

    // 分别生成所有子组件
    List<Widget> finishedCourses = _generateCourseList(_allCourseList, true);
    List<Widget> unfinishedCourses =
    _generateCourseList(_reminderCourseList, false);

    // 构建待交作业数提示卡片
    Widget tip = Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text(
          '有${unfinishedCourses.length}门课程有待交作业', textAlign: TextAlign.center,),
      ),
    );

    // 生成组件列表
    List<Widget> childrenList = []
      ..add(tip)
      ..addAll(unfinishedCourses)..addAll(finishedCourses);

    // 放进列表里显示出来
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: childrenList,
    );
  }

  _generateCourseList(List<Course> courseList, bool finished) {
    return List.generate(
      courseList.length,
          (index) {
        return Card(
          child: ListTile(
            leading: finished
                ? Icon(
              Icons.bookmark,
              color: Colors.orange,
            )
                : Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: Text(courseList[index].name),
            onTap: () =>
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) =>
                        HomeworkPage(course: courseList[index]),
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildHomeworkList() {
    // 未完成的作业和已完成的作业
    List<Homework> finished =
    _homeworkList.where((homework) => homework.resultUrl != null).toList();
    List<Homework> unfinished =
    _homeworkList.where((homework) => homework.resultUrl == null).toList();

    // 分别生成所有子组件
    List<HomeworkItem> finishedItems = _generateItemList(finished, true);
    List<HomeworkItem> unfinishedItems = _generateItemList(unfinished, false);

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
  List<HomeworkItem> _generateItemList(List<Homework> homeworkList,
      bool finished) {
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

  _getData() async {
    if (this.widget.course == null) {
      // 获取有待交作业的课程列表
      _setLoadingText('获取课程信息');
      await _getRootData();
    } else {
      // 获取当前课程的所有作业
      await _getHomeworkList();
    }
  }

  _login() async {
    if (!DataStore.isSignedInJxxt) {
      _setLoadingText('登录中');
      int code = await login(DataStore.username, DataStore.jxxtPassword);
      if (code != 200) {
        throw Exception('登录错误，错误码$code');
      }
      DataStore.isSignedInJxxt = true;
    }
  }

  _getRootData() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    try {
      // 登录
      await _login();
      await _getAllCourse();
      await _getReminderList();
    } catch (e) {
      print(e.toString());
      _setErrorText(e.toString());
      _reminderCourseList = null;
      _allCourseList = null;
    } finally {
      // 更新
      setState(() {
        _reminderCourseList = _reminderCourseList;
        _allCourseList = _allCourseList;
      });
      _isLoading = false;
    }
  }

  /// 获取所有课程的列表
  _getAllCourse() async {
    // 获取课程信息
    _allCourseList = await getAllCourses();
    if (_allCourseList == null) {
      throw Exception('课程获取失败');
    }
  }

  /// 获取有待交作业的课程列表
  _getReminderList() async {
    // 获取课程信息
    _reminderCourseList = await getReminderList();
    if (_reminderCourseList == null) {
      throw Exception('课程获取失败');
    }
  }

  /// 获取当前课程的所有作业
  _getHomeworkList() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    try {
      // 登录
      await _login();
      _homeworkList = new List();

      // 获取作业信息
      Course course = this.widget.course;
      _setLoadingText('获取${course.name}的作业');
      var list = await getHomeworkList(course.id);
      list.forEach((homework) => homework.course = course);

      _homeworkList.addAll(list);
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

  _showHomeworkDetail(Homework homework) async {
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
                  fontSize: 24.0,
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
