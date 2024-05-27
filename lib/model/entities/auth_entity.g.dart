// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthEntity _$AuthEntityFromJson(Map<String, dynamic> json) => AuthEntity(
      json['login'] as String,
      json['password'] as String,
      json['role'] as String,
    );

Map<String, dynamic> _$AuthEntityToJson(AuthEntity instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'role': instance.role,
    };
