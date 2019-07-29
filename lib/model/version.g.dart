// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) {
  return Version(json['versionCode'] as int, json['versionName'] as String,
      json['changelog'] as String);
}

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
      'changelog': instance.changelog
    };
