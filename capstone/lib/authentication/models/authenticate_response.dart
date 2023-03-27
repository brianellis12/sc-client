import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'authenticate_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthenticateResponse {
  AuthenticateResponse();

  @JsonKey(name: 'access_token')
  String? accessToken;

  late User? user;

  @JsonKey(name: 'new_user')
  bool? newUser;

  @JsonKey(name: 'incomplete_token')
  bool incompleteToken = false;

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticateResponseToJson(this);
}
