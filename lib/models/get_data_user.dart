import 'package:json_annotation/json_annotation.dart';

part 'get_data_user.g.dart';

@JsonSerializable()
class GetDataUser {
  GetDataUser({
    required this.username,
    required this.creationTime,
    required this.email,
    required this.role,
    required this.userUid,
  });
  factory GetDataUser.fromJson(Map<String, dynamic> json) =>
      _$GetDataUserFromJson(json);
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'user_uid')
  String userUid;
  @JsonKey(name: 'role')
  String role;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'creation_time')
  String creationTime;

  Map<String, dynamic> toJson() => _$GetDataUserToJson(this);
}
