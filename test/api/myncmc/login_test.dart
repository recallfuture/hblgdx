import 'package:hblgdx/api/myncmc/login.dart';
import 'package:test_api/test_api.dart';

void main() {
  test('login should success', () async {
    String username = '201643710101';
    String password = '201643710101';
    int code = await login(username, password);
    expect(code, 200);
  });
}
