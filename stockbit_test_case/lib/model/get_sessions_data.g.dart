// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_sessions_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSessionsData _$GetSessionsDataFromJson(Map<String, dynamic> json) =>
    GetSessionsData(
      params: (json['params'] as List<dynamic>?)
              ?.map(
                  (e) => SettleSessionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetSessionsDataToJson(GetSessionsData instance) =>
    <String, dynamic>{
      'params': instance.params,
    };
