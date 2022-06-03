import 'package:json_annotation/json_annotation.dart';
import 'package:stockbit_test_case/model/settle_session_data.dart';

part 'get_sessions_data.g.dart';

@JsonSerializable()
class GetSessionsData {
  @JsonKey(defaultValue: [])
  List<SettleSessionData> params = [];

  GetSessionsData({this.params = const []});

  factory GetSessionsData.fromJson(Map<String, dynamic> json) => _$GetSessionsDataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$GetSessionsDataToJson(this);
}
