// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'census_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CensusData _$CensusDataFromJson(Map<String, dynamic> json) => CensusData(
      currentCensusData: (json['currentCensusData'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CensusDataToJson(CensusData instance) =>
    <String, dynamic>{
      'currentCensusData': instance.currentCensusData,
    };
