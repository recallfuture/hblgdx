import 'dart:convert';

import 'package:hblgdx/model/score_report.dart';
import 'package:hblgdx/utils/request.dart';

import 'base.dart';

Future<String> getScoreJson() async {
  await request.get(infoUrl);
  await request.get(prepareUrl);
  return (await request.get(scoreUrl)).data;
}

ScoreReport getScoreReport(String json) {
  return ScoreReport.fromJson(JsonDecoder().convert(json));
}
