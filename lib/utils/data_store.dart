import 'package:get_version/get_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 简单粗暴的单例全局数据管理
class DataStore {
  static SharedPreferences _sp;

  // 是否首次打开应用
  static bool _isFirstTime = true;

  // 是否已经登录过（下次进入直接进主页）
  static bool _isSignedIn = false;

  // 是否登录了教务系统
  static bool isSignedInJwxt = false;

  // 是否登录了教学系统
  static bool isSignedInJxxt = false;

  // 是否登录了煤医查询系统
  static bool isSignedInMyncmc = false;

  // 当前的版本号全名
  static String version;

  // 是否忽略本次更新
  static bool _ignoreUpdate = false;

  static init() async {
    _sp = await SharedPreferences.getInstance();
    version = await GetVersion.projectVersion;
  }

  static bool get isFirstTime {
    return _sp.getBool('isFirstTime') ?? _isFirstTime;
  }

  static setIsFirstTime(bool value) async {
    await _sp.setBool('isFirstTime', value);
  }

  static String get username {
    return _sp.getString('username');
  }

  // 身份信息
  static setUsername(value) async {
    await _sp.setString('username', value);
  }

  static String get jwxtPassword {
    return _sp.getString('jwxtPassword');
  }

  static setJwxtPassword(value) async {
    await _sp.setString('jwxtPassword', value);
  }

  static String get jxxtPassword {
    return _sp.getString('jxxtPassword');
  }

  static setJxxtPassword(value) async {
    await _sp.setString('jxxtPassword', value);
  }

  static bool get isSignedIn {
    return _sp.getBool('isSignedIn') ?? _isSignedIn;
  }

  static setIsSignedIn(bool value) async {
    await _sp.setBool('isSignedIn', value);
  }

  // 成绩信息，缓存到本地
  static String get scoreReportJson {
    return _sp.getString('scoreReport');
  }

  static setScoreReport(value) async {
    await _sp.setString('scoreReport', value);
  }

  // 是否忽略本次版本更新
  static bool get ignoreUpdate {
    return _sp.getBool('ignoreUpdate') ?? _ignoreUpdate;
  }

  static setIgnoreUpdate(value) async {
    await _sp.setBool('ignoreUpdate', value);
  }
}
