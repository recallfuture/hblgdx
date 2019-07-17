// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreReport _$ScoreReportFromJson(Map<String, dynamic> json) {
  return ScoreReport(
      json['xingming'] as String,
      json['xuehao'] as String,
      json['xisuo'] as String,
      json['banji'] as String,
      (json['chengji'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$ScoreReportToJson(ScoreReport instance) =>
    <String, dynamic>{
      'xingming': instance.name,
      'xuehao': instance.number,
      'xisuo': instance.departmentName,
      'banji': instance.className,
      'chengji': instance.chengji
    };
