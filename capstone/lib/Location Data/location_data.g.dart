// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      values: json['values'] as List<String>,
      headerValue: json['headerValue'] as String,
      isExpanded: json['isExpanded'] as bool? ?? false,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'values': instance.values,
      'headerValue': instance.headerValue,
      'isExpanded': instance.isExpanded,
    };
