import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  int versionCode;
  String versionName;
  String changelog;
  String downloadUrl;

  Version(this.versionCode, this.versionName, this.changelog, this.downloadUrl);

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
