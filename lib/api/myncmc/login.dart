import 'package:hblgdx/utils/request.dart';

import 'base.dart';

Future<String> _getValidateCode() async {
  // 获得必要的session
  await request.get(sessionUrl);

  return await request.getContent(validateCodeStringUrl);
}

/// 登录
///
/// 200为成功
/// 400为帐号或密码错误
/// 401为验证码错误
/// 500为网络错误
Future<int> login(String username, String password) async {
  if (username == null ||
      username.isEmpty ||
      password == null ||
      password.isEmpty) {
    return 400;
  }

  // 获取验证码
  String code = await _getValidateCode();
  print(code);
  if (code == null) {
    return 401;
  }

  // 登录
  String url = '$loginUrl&zjh=$username&mm=$password&v_yzm=$code';
  String response = await request.getContent(url);
  if (response == null) {
    return 500;
  } else if (response != 'ok') {
    return 400;
  }

  return 200;
}
