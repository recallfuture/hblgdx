import 'package:flutter/material.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/api/jxxt/resource.dart';
import 'package:hblgdx/model/course.dart';
import 'package:hblgdx/model/resource.dart';
import 'package:hblgdx/utils/data_store.dart';

class ResourcePage extends StatefulWidget {
  final String courseId;
  final String folderId;

  ResourcePage({this.courseId = '0', this.folderId = '0'});

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  Future _future;
  List<Resource> _resources;
  List<Course> _allCourses;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('资源下载'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 53, 83, 108),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: _buildFuture(),
      ),
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
    if (this.widget.courseId == '0') {
      return _buildCourseList();
    } else {
      return _buildResourceList();
    }
  }

  Widget _buildCourseList() {
    if (_allCourses == null) {
      return _buildErrorCard();
    }

    return ListView(
      children: List<Widget>.generate(_allCourses.length, (index) {
        return ListTile(
          leading: ImageIcon(Image
              .asset('assets/resource.png')
              .image),
          title: Text(_allCourses[index].name),
          onTap: () =>
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) =>
                      ResourcePage(courseId: _allCourses[index].id),
                ),
              ),
        );
      }),
    );
  }

  Widget _buildResourceList() {
    if (_resources == null) {
      return _buildErrorCard();
    }

    return ListView(
      children: List<Widget>.generate(_resources.length, (index) {
        return ListTile(
          leading: _resources[index].type == ResourceType.folder
              ? ImageIcon(Image
              .asset('assets/resource.png')
              .image)
              : ImageIcon(Image
              .asset('assets/file.png')
              .image),
          title: Text(_resources[index].name),
          onTap: () {
            if (_resources[index].type == ResourceType.folder) {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) =>
                      ResourcePage(
                        courseId: this.widget.courseId,
                        folderId: _resources[index].folderId,
                      ),
                ),
              );
            } else {}
          },
        );
      }),
    );
  }

  Widget _buildErrorCard() {
    // 套上ListView防止高度出界
    return ListView(
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
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    try {
      // 登录
      if (!DataStore.isSignedInJxxt) {
        _setLoadingText('登录中');
        int code = await login(DataStore.username, DataStore.jwxtPassword);
        if (code != 200) {
          throw Exception('登录错误，错误码$code');
        }
        DataStore.isSignedInJxxt = true;
      }

      // 获取数据
      if (this.widget.courseId == '0') {
        // 获取课程列表
        _setLoadingText('获取课程列表');
        _allCourses = await getAllCourses();
        if (_allCourses == null) {
          throw Exception('课程列表获取失败');
        }
      } else {
        // 获取当前课程的资源目录
        _setLoadingText('获取资源目录');
        _resources =
        await getResourceList(this.widget.courseId, this.widget.folderId);
        if (_resources == null) {
          throw Exception('课程资源获取失败');
        }
      }
    } catch (e) {
      // 错误处理
      print(e.toString());
      _setErrorText(e.toString());
      _allCourses = null;
      _resources = null;
    } finally {
      // 更新
      setState(() {
        _allCourses = _allCourses;
        _resources = _resources;
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
