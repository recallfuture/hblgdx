import 'package:hblgdx/api/jxxt/login.dart';
import 'package:test_api/test_api.dart';

void main() {
  test('login should success', () async {
    String username = '201643710104';
    String password = 'hblgdx123';
    int code = await login(username, password);
    expect(code, 200);
  });
}
