// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_session_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleSessionData _$SettleSessionDataFromJson(Map<String, dynamic> json) =>
    SettleSessionData(
      expiry: json['expiry'] as int? ?? 0,
      topic: json['topic'] as String? ?? "",
      metaData: json['metaData'] == null
          ? null
          : MetaData.fromJson(json['metaData'] as Map<String, dynamic>),
      namespaces: json['namespaces'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SettleSessionDataToJson(SettleSessionData instance) =>
    <String, dynamic>{
      'expiry': instance.expiry,
      'topic': instance.topic,
      'metaData': instance.metaData,
      'namespaces': instance.namespaces,
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      url: json['url'] as String? ?? "",
      icons:
          (json['icons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      description: json['description'] as String? ?? "",
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
      'url': instance.url,
      'icons': instance.icons,
    };
