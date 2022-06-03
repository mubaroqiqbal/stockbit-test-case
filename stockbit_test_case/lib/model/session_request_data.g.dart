// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionRequestData _$SessionRequestDataFromJson(Map<String, dynamic> json) =>
    SessionRequestData(
      name: json['name'] as String? ?? "",
      url: json['url'] as String? ?? "",
      description: json['description'] as String? ?? "",
      icons:
          (json['icons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      proposerPublicKey: json['proposerPublicKey'] as String? ?? "",
      relayProtocol: json['relayProtocol'] as String? ?? "",
      requiredNamespaces:
          json['requiredNamespaces'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SessionRequestDataToJson(SessionRequestData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'proposerPublicKey': instance.proposerPublicKey,
      'relayProtocol': instance.relayProtocol,
      'url': instance.url,
      'description': instance.description,
      'icons': instance.icons,
      'requiredNamespaces': instance.requiredNamespaces,
    };
