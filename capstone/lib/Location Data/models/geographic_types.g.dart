// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geographic_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeographicTypes _$GeographicTypesFromJson(Map<String, dynamic> json) =>
    GeographicTypes(
      stateCode: json['state'] as String?,
      county: json['county'] as String?,
      tract: json['tract'] as String?,
    );

Map<String, dynamic> _$GeographicTypesToJson(GeographicTypes instance) =>
    <String, dynamic>{
      'state': instance.stateCode,
      'county': instance.county,
      'tract': instance.tract,
    };
