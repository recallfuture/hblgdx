import 'package:hblgdx/api/myncmc/login.dart';
import 'package:hblgdx/api/myncmc/score.dart';
import 'package:test_api/test_api.dart';

void main() {
  test('getScoreReport should success', () async {
    String username = '201643710101';
    String password = '201643710101';
    await login(username, password);

    var json = await getScoreJson();
    print(json);
    expect(json != null, true);

    var scoreReport = getScoreReportFromJson(json);
    print(scoreReport);
    expect(scoreReport != null, true);
  });
}
