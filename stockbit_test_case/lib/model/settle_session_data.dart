import 'package:json_annotation/json_annotation.dart';

part 'settle_session_data.g.dart';

@JsonSerializable()
class SettleSessionData {
  int expiry;
  String topic;
  MetaData? metaData;
  Map<String, dynamic> namespaces;

  SettleSessionData({
    this.expiry = 0,
    this.topic = "",
    this.metaData,
    this.namespaces = const {},
  });

  factory SettleSessionData.fromJson(Map<String, dynamic> json) => _$SettleSessionDataFromJson(json);
  Map<dynamic, dynamic> toJson() => _$SettleSessionDataToJson(this);
}

@JsonSerializable()
class MetaData {
  String description;
  String name;
  String url;
  List<String> icons;

  MetaData({this.url = "", this.icons = const <String>[], this.description = "", this.name = ""});

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
  Map<dynamic, dynamic> toJson() => _$MetaDataToJson(this);
}
