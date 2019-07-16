import 'dart:typed_data';

import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:hblgdx/utils/regex.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

/// 获取验证码
/// 返回值直接喂给Image.memory
Future<Uint8List> getValidateCode() async {
  Response<List<int>> response = await request.getStream(validateCodeUrl);
  return Uint8List.fromList(response.data);
}

/// 错误的查找正则和状态码
const Map<String, int> _errorMap = {
  r'<title>学分制综合教务</title>': 200, // 登录成功
  r'您的密码不正确，请您重新输入！': 400,
  r'你输入的验证码错误，请您重新输入！': 401,
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

/// 获取登录表单数据
FormData _getFormData(String username, String password, String code) {
  return FormData.from({
    'zjh1': '',
    'tips': '',
    'lx': '',
    'evalue': '',
    'fs': '',
    'dzslh': '',
    'zjh': username,
    'mm': password,
    'v_yzm': code,
  });
}

/// 登录
///
/// 参数:
/// username: 学号
/// password: 密码
/// code: 验证码
///
/// 返回值:
/// 200为成功
/// 400为帐号或密码错误
/// 401为验证码错误
Future<int> login(String username, String password, String code) async {
  if (username == null ||
      username.isEmpty ||
      password == null ||
      password.isEmpty ||
      code == null ||
      code.isEmpty) {
    return 400;
  }

  FormData formData = _getFormData(username, password, code);

  // 提交登录表单
  Response<List<int>> response = await request.postStream(loginUrl, formData);

  if (response.statusCode == 200) {
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
