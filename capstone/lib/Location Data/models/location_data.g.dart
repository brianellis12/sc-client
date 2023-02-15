// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      values:
          (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
      headerValue: json['headerValue'] as String,
      isExpanded: json['isExpanded'] as bool? ?? false,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'headerValue': instance.headerValue,
      'values': instance.values,
      'isExpanded': instance.isExpanded,
    };
