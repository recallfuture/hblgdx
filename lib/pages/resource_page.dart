import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/api/jxxt/resource.dart';
import 'package:hblgdx/model/jxxt/course.dart';
import 'package:hblgdx/model/jxxt/resource.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:hblgdx/utils/request.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'download_manager_page.dart';

class ResourcePage extends StatefulWidget {
  final Course course;
  final Resource resource;

  ResourcePage({this.course, this.resource});

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage>
    with TickerProviderStateMixin {
  Future _future;
  List<Resource> _resources;
  List<Course> _allCourses;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  // 是否有下载好还没查看的资源
  // 设为static，全局共享
  static bool _hasDownloaded = false;

  var _sequenceAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _initAnimation();
  }

  _initAnimation() {
    _animationController = AnimationController(vsync: this);
    _sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
        animatable: Tween<double>(begin: 24, end: 32),
        from: Duration(seconds: 0),
        to: Duration(milliseconds: 300),
        tag: "size",
        curve: Curves.fastOutSlowIn)
        .addAnimatable(
        animatable: Tween<double>(begin: 32, end: 24),
        from: Duration(milliseconds: 300),
        to: Duration(milliseconds: 600),
        tag: "size",
        curve: Curves.fastOutSlowIn)
        .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _future = null;
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('资源下载'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 53, 83, 108),
        leading: this.widget.course == null
            ? IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )
            : null,
        actions: <Widget>[
          _buildAnimatedBuilder(),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: _buildFuture(),
    );
  }

  Widget _buildAnimatedBuilder() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IconButton(
              iconSize: _sequenceAnimation['size'].value,
              icon: Icon(Icons.file_download),
              onPressed: _showDownloadManagerPage,
            ),
            // 小红点
            _hasDownloaded
                ? Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                width: 10,
                height: 10,
              ),
            )
                : Container(),
          ],
        );
      },
    );
  }

  _showDownloadManagerPage() async {
    try {
      await _checkAndRequestPermission();
      Directory dir = await _getDownloadDir();
      _setHasDownloaded(false);
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => DownloadManagerPage(context, dir),
        ),
      );
    } catch (e) {
      print(e.toString());
      _showToast('无权访问本地文件');
    }
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
                      ResourcePage(course: _allCourses[index]),
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
              // 是文件夹的话就递归打开本页面以显示文件夹中的内容
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) =>
                      ResourcePage(
                        course: this.widget.course,
                        resource: _resources[index],
                      ),
                ),
              );
            } else {
              // 否则弹出下载提示框
              _showDownloadDialog(_resources[index]);
            }
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

  _checkAndRequestPermission() async {
    var permissionHandler = PermissionHandler();
    var permission =
    await permissionHandler.checkPermissionStatus(PermissionGroup.storage);

    // 获取文件访问权限
    if (permission != PermissionStatus.granted) {
      _showToast('请授权以访问本地文件');
      await permissionHandler.requestPermissions([PermissionGroup.storage]);
    }
  }

  Future<Directory> _getDownloadDir() async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    if (this.widget.course != null) {
      dir = Directory('${dir.path}/课程资源/${this.widget.course.name}');
    } else {
      dir = Directory('${dir.path}/课程资源/');
    }

    bool exist = await dir.exists();
    if (!exist) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  _showDownloadDialog(Resource resource) async {
    String path;

    try {
      // 检查权限
      await _checkAndRequestPermission();

      // 获取真正的文件名并缓存
      if (resource.realName == null) {
        resource.realName = await getFileName(resource);
      }
      String fileName = resource.realName;

      // 获取下载目录，不存在就创建
      Directory dir = await _getDownloadDir();
      path = '${dir.path}/$fileName';
      path = path.replaceAll(' ', '');
    } catch (e) {
      print(e.toString());
      _showToast('下载失败');
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('确定下载此文件么'),
          content: Text('将下载到$path'),
          actions: <Widget>[
            MaterialButton(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context),
            ),
            MaterialButton(
              child: Text('确认'),
              onPressed: () {
                _download(resource, path);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _download(Resource resource, String path) {
    try {
      request.download(
        resource.downloadUrl,
        path,
        onReceiveProgress: (count, total) async {
          int progress = (count / total * 100).floor();
          _showToast('${resource.realName}：$progress%');
          if (progress == 100) {
            _showToast('${resource.realName}下载完成，请到下载管理查看');
            _setHasDownloaded(true);
            await _animationController.forward();
            _animationController.reset();
          }
        },
      );
    } catch (e) {
      print(e.toString());
      _showToast('下载失败');
    }
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
      if (this.widget.course == null) {
        // 获取课程列表
        _setLoadingText('获取课程列表');
        _allCourses = await getAllCourses();
        if (_allCourses == null) {
          throw Exception('课程列表获取失败');
        }
      } else {
        // 获取当前课程的资源目录
        _setLoadingText('获取资源目录');
        _resources = await getResourceList(
          this.widget.course.id,
          this.widget.resource?.folderId ?? '0',
        );
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

  _setHasDownloaded(bool value) {
    setState(() {
      _hasDownloaded = value;
    });
  }

  _showToast(String msg) {
    showToast(
      msg,
      duration: Duration(seconds: 2),
      position: ToastPosition.top,
      backgroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.black),
    );
  }
}
