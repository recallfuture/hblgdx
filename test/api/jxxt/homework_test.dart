import 'package:hblgdx/api/jxxt/homework.dart';
import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/model/homework.dart';
import 'package:test_api/test_api.dart';

void main() {
  setUpAll(() async {
    String username = '201643710101';
    String password = 'hblgdx123';
    await login(username, password);
  });

  tearDownAll(() async {
    await logout();
  });

  test('getCourseMap should success', () async {
    Map map = await getCourseMap();
    expect(map != null, true);
  });

  test('getHomeworkList should success', () async {
    List<Homework> homework = await getHomeworkList('32340');
    expect(homework.length > 0, true);
  });

  test('getHomeworkList should success', () async {
    String detail = await getHomeworkDetail('14703');
    expect(detail != null, true);
  });
}
