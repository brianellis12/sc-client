// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sections _$SectionsFromJson(Map<String, dynamic> json) => Sections(
      currentSections: (json['currentSections'] as List<dynamic>?)!
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SectionsToJson(Sections instance) => <String, dynamic>{
      'currentSections': instance.currentSections,
    };
