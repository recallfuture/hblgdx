import 'package:flutter/material.dart';
import 'package:hblgdx/api/jxxt/login.dart' deferred as jxxt;
import 'package:hblgdx/api/myncmc/login.dart' deferred as myncmc;
import 'package:hblgdx/utils/data_store.dart';
import 'package:oktoast/oktoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _jwPasswordFieldNode = FocusNode();
  FocusNode _jxPasswordFieldNode = FocusNode();
  String _username = DataStore.username;
  String _jwPassword = DataStore.jwxtPassword;
  String _jxPassword = DataStore.jxxtPassword;
  bool _isObscure = true;
  Color _eyeColor = Colors.white54;
  bool _waiting = false;

  final _errorCode = {
    400: '请检查帐号密码',
    401: 'token错误',
    403: '帐号已经被锁，请明天再试',
    500: '请检查网络',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 22, 22, 32),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'assets/colors.png',
              scale: 3,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
//            // 在需要返回上一界面的时候取消注释
//            // appBar会自动添加返回按钮
//            appBar: AppBar(
//              backgroundColor: Colors.transparent,
//              elevation: 0,
//            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 70.0),
                children: <Widget>[
                  SizedBox(height: 200.0),
                  buildTitle(),
                  SizedBox(height: 40.0),
                  buildUsernameTextField(context),
                  SizedBox(height: 30.0),
                  buildJxxtPasswordTextField(context),
                  SizedBox(height: 30.0),
                  buildJwxtPasswordTextField(context),
                  SizedBox(height: 30.0),
                  buildLoginButton(context),
                  SizedBox(height: 10.0),
                  buildHelpLink(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      '校      园      查',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildUsernameTextField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      initialValue: this._username,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: new BorderSide(color: Colors.white),
        ),
        labelText: '请输入学号',
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (String value) {
        setState(() {
          _username = value;
        });
        if (value.isEmpty) {
          return '不能为空';
        }
        return null;
      },
      onSaved: (String value) => _username = value.trim(),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_jxPasswordFieldNode),
    );
  }

  Widget buildJxxtPasswordTextField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      focusNode: _jxPasswordFieldNode,
      initialValue: this._jxPassword,
      onSaved: (String value) => _jxPassword = value.trim(),
      obscureText: _isObscure,
      validator: (String value) {
        setState(() {
          _jxPassword = value;
        });
        if (value.isEmpty) {
          return '不能为空';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        labelText: '教学系统密码',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: new BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(
                  () {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure ? Colors.white54 : Colors.white;
              },
            );
          },
        ),
      ),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_jwPasswordFieldNode),
    );
  }

  Widget buildJwxtPasswordTextField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      focusNode: _jwPasswordFieldNode,
      initialValue: this._jwPassword,
      onSaved: (String value) => _jwPassword = value.trim(),
      obscureText: _isObscure,
      validator: (String value) {
        setState(() {
          _jwPassword = value;
        });
        if (value.isEmpty) {
          return '不能为空';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        labelText: '教务系统密码',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: new BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(
              () {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure ? Colors.white54 : Colors.white;
              },
            );
          },
        ),
      ),
      onEditingComplete: () {
        _jwPasswordFieldNode.unfocus();
        _onPressed();
      },
    );
  }

  Widget buildHelpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          child: Text(
            '遇到问题？',
            style: TextStyle(color: Colors.white60),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/faq');
          },
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return MaterialButton(
      child: _waiting
          ? CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              '登录',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      color: Colors.deepPurpleAccent,
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: StadiumBorder(),
      onPressed: _onPressed,
    );
  }

  _onPressed() async {
    try {
      await _submit();
    } catch (e) {
      _stopWait();
      _showToast('登录失败(${e.toString()})');
    }
  }

  // 提交表单并登录
  _submit() async {
    // 正在登录等待中就不继续执行下面的了
    if (this._waiting) {
      return;
    }

    // 检验表单数据
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    // 放在后面防止无限转圈
    _startWait();

    int code;

    _showToast('正在登录教学系统');
    code = await jxxt.login(_username, _jxPassword);
    if (code != 200) {
      _stopWait();
      _showToast('教学系统登录失败(${_errorCode[code]}，错误码$code)');
      return;
    }

    _showToast('正在登录教务系统');
    code = await myncmc.login(_username, _jwPassword);
    if (code != 200) {
      _stopWait();
      _showToast('教务系统登录失败(${_errorCode[code]}，错误码$code)');
      return;
    }

    // 存储下来
    await DataStore.setIsSignedIn(true);
    await DataStore.setUsername(_username);
    await DataStore.setJxxtPassword(_jxPassword);
    await DataStore.setJwxtPassword(_jwPassword);
    DataStore.isSignedInJxxt = true;
    DataStore.isSignedInMyncmc = true;

    _stopWait();
    _showToast('登录成功');

    // 回到主页并不允许返回
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
          (route) => route == null,
    );
  }

  _startWait() {
    setState(() {
      this._waiting = true;
    });
  }

  _stopWait() {
    setState(() {
      this._waiting = false;
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
