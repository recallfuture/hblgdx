import 'package:shared_preferences/shared_preferences.dart';

/// 简单粗暴的单例全局数据管理
class DataStore {
  static SharedPreferences _sp;

  // 是否首次打开应用
  static bool _isFirstTime = true;

  // 用户信息
  static String _username;
  static String _jwxtPassword;
  static String _jxxtPassword;

  // 是否已经登录过（下次进入直接进主页）
  static bool _isSignedIn = false;

  // 是否登录了教务系统
  static bool isSignedInJwxt = false;

  // 是否登录了教学系统
  static bool isSignedInJxxt = false;

  // 是否登录了煤医查询系统
  static bool isSignedInMyncmc = false;

  static init() async {
    _sp = await SharedPreferences.getInstance();
  }

  static bool get isFirstTime {
    return _sp.getBool('isFirstTime') == null
        ? _isFirstTime
        : _sp.getBool('isFirstTime');
  }

  static setIsFirstTime(bool value) async {
    await _sp.setBool('isFirstTime', value);
  }

  static String get username {
    return _sp.getString('username');
  }

  static setUsername(value) async {
    await _sp.setString('username', value);
  }

  static String get jwxtPassword {
    return _sp.getString('jwxtPassword');
  }

  static setjwxtPassword(value) async {
    await _sp.setString('jwxtPassword', value);
  }

  static String get jxxtPassword {
    return _sp.getString('jxxtPassword');
  }

  static setjxxtPassword(value) async {
    await _sp.setString('jxxtPassword', value);
  }

  static bool get isSignedIn {
    return _sp.getBool('isSignedIn') == null
        ? _isSignedIn
        : _sp.getBool('isSignedIn');
  }

  static setIsSignedIn(bool value) async {
    await _sp.setBool('isSignedIn', value);
  }
}
