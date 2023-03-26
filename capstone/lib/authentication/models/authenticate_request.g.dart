// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateRequest _$AuthenticateRequestFromJson(Map<String, dynamic> json) =>
    AuthenticateRequest()
      ..token = json['token'] as String
      ..firstName = json['first_name'] as String?
      ..lastName = json['last_name'] as String?;

Map<String, dynamic> _$AuthenticateRequestToJson(
        AuthenticateRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };
