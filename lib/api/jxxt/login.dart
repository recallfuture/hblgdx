import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

/// 获取token
Future<String> _getToken() async {
  String content = await request.getContent(loginUrl);
  if (content == null) {
    return null;
  }

  Match match = matchOne(
      r'<input type="hidden" name="logintoken" value="(\d+)"/>', content);
  if (match != null) {
    return match.group(1);
  }
  return null;
}

/// 获取登录表单数据
FormData _getFormData(String username, String password, String token) {
  return FormData.from({
    'logintoken': token,
    'enterLid': '',
    'IPT_LOGINUSERNAME': username,
    'IPT_LOGINPASSWORD': password,
  });
}

/// 错误的查找正则和状态码
const Map<String, int> _errorMap = {
  r'用户名或密码错误！': 400,
  r'您已登录失败5次，账号被锁定，请您明天再试！': 403
};

/// 用errorMap中的数据检查content中的具体错误
///
/// content: 要检测的内容
/// defaultCode: 没有查找到的话返回这个值
int _getErrorCode(String content, int defaultCode) {
  for (String regex in _errorMap.keys) {
    if (matchOne(regex, content) != null) {
      return _errorMap[regex];
    }
  }
  return defaultCode;
}

/// 登录
///
/// username: 用户名
/// password: 密码
///
/// 返回值：状态码
/// 200为成功
/// 400为帐号或密码错误
/// 401为token错误
/// 403为帐号被锁，无权进入
/// 500为网络错误
Future<int> login(String username, String password) async {
  if (username == null ||
      username.isEmpty ||
      password == null ||
      password.isEmpty) {
    return 400;
  }

  // 获取token
  String token = await _getToken();
  if (token == null) {
    return 401;
  }

  // 获取登录表单数据
  FormData formData = _getFormData(username, password, token);

  // 提交登录表单
  Response<List<int>> response = await request.postStream(loginUrl, formData);

  // 重定向意味着成功登录了
  if (response.statusCode == 302) {
    // 登录成功
    return 200;
  } else if (response.statusCode == 200) {
    // 转码
    String content = gbk.decode(response.data);

    // 返回错误码
    return _getErrorCode(content, 400);
  } else {
    return 500;
  }
}

/// 注销
Future<void> logout() async {
  await request.get(logoutUrl);
}
