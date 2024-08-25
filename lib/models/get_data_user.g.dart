// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_data_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDataUser _$GetDataUserFromJson(Map<String, dynamic> json) => GetDataUser(
      username: json['username'] as String,
      creationTime: json['creation_time'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      userUid: json['user_uid'] as String,
    );

Map<String, dynamic> _$GetDataUserToJson(GetDataUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'user_uid': instance.userUid,
      'role': instance.role,
      'email': instance.email,
      'creation_time': instance.creationTime,
    };
