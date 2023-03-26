import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  User();
  int id = 0;

  @JsonKey(name: 'first_name')
  String firstName = '';

  @JsonKey(name: 'last_name')
  String lastName = '';

  @JsonKey(name: 'email')
  String email = '';

  @JsonKey(name: 'supervisor_id')
  int? supervisorId;

  @JsonKey(name: 'mentor_id')
  int? mentorId;

  @JsonKey(name: 'practice_area')
  String practiceArea = '';

  @JsonKey(name: 'is_admin')
  bool? isAdmin = false;

  String get fullName => '$firstName $lastName';

  String get initials => fullName
      .split(' ')
      .map(
        (part) => part[0],
      )
      .join()
      .toUpperCase();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
