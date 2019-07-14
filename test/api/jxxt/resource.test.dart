import 'package:hblgdx/api/jxxt/login.dart';
import 'package:hblgdx/api/jxxt/resource.dart';
import 'package:hblgdx/model/resource.dart';
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

  test('getResourceList should success', () async {
    List<Resource> resources = await getResourceList('32340');
    expect(resources != null, true);
    expect(resources.length == 2, true);
    expect(resources[0].type, ResourceType.folder);
  });

  test('getResourceList should success', () async {
    List<Resource> resources = await getResourceList('32340', '154310');
    expect(resources != null, true);
    expect(resources.length == 2, true);
    expect(resources[0].type, ResourceType.file);

    String url =
        'http://elearning.ncst.edu.cn/meol/common/script/download.jsp?fileid=65101&resid=87283&lid=32340';
    expect(resources[0].downloadUrl, url);
  });
}
