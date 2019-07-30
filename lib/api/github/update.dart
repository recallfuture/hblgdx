import 'dart:convert';

import 'package:hblgdx/model/version.dart';
import 'package:hblgdx/utils/request.dart';

String versionUrl = 'https://gitee.com/recallfuture/hblgdx/raw/master/version';

Future<Version> getLatestVersion() async {
  Response response = await request.get(versionUrl);
  String json = response.data;
  return Version.fromJson(JsonDecoder().convert(json));
}
