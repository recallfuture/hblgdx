import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  Future _future;
  bool _isLoading = false;
  String _loadingText = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();
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
        title: Text('标题'),
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

  _onRefresh() {}

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
    return Container();
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
