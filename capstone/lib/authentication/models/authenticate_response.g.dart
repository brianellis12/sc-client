// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateResponse _$AuthenticateResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticateResponse()
      ..accessToken = json['access_token'] as String?
      ..user = json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>)
      ..newUser = json['new_user'] as bool?
      ..incompleteToken = json['incomplete_token'] as bool;

Map<String, dynamic> _$AuthenticateResponseToJson(
        AuthenticateResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'user': instance.user?.toJson(),
      'new_user': instance.newUser,
      'incomplete_token': instance.incompleteToken,
    };
