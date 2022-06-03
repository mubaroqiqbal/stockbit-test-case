import 'package:json_annotation/json_annotation.dart';

part 'session_request_data.g.dart';

@JsonSerializable()
class SessionRequestData {
  String name;
  String proposerPublicKey;
  String relayProtocol;
  String url;
  String description;
  List<String> icons;
  Map<String, dynamic> requiredNamespaces;

  SessionRequestData({
    this.name = "",
    this.url = "",
    this.description = "",
    this.icons = const <String>[],
    this.proposerPublicKey = "",
    this.relayProtocol = "",
    this.requiredNamespaces = const {},
  });

  factory SessionRequestData.fromJson(Map<String, dynamic> json) => _$SessionRequestDataFromJson(json);
  Map<dynamic, dynamic> toJson() => _$SessionRequestDataToJson(this);
}
