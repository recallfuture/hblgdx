import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class DownloadManagerPage extends StatelessWidget {
  final BuildContext context;
  final Directory dir;

  DownloadManagerPage(this.context, this.dir);

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('下载管理'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 53, 83, 108),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: _buildFileList(),
      ),
    );
  }

  Widget _buildFileList() {
    List<FileSystemEntity> fileList = dir.listSync();

    return ListView(
      children: List<Widget>.generate(fileList.length, (index) {
        var file = fileList[index];
        var stat = file.statSync();
        String path = file.path;
        String name = path.substring(path.lastIndexOf('/') + 1);
        bool isDir = stat.type != FileSystemEntityType.file;

        return ListTile(
          leading: isDir
              ? ImageIcon(Image.asset('assets/resource.png').image)
              : ImageIcon(Image.asset('assets/file.png').image),
          title: Text(name),
          onTap: () async {
            if (isDir) {
              Directory dir = Directory(path);
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => DownloadManagerPage(context, dir),
                ),
              );
            } else {
              print(path);
              OpenFile.open(path);
            }
          },
        );
      }),
    );
  }
}
