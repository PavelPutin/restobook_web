// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthEntity _$AuthEntityFromJson(Map<String, dynamic> json) => AuthEntity(
      Employee.fromJson(json['employee'] as Map<String, dynamic>),
      json['password'] as String,
      json['role'] as String,
    );

Map<String, dynamic> _$AuthEntityToJson(AuthEntity instance) =>
    <String, dynamic>{
      'employee': instance.employee,
      'password': instance.password,
      'role': instance.role,
    };
