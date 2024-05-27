// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      (json['id'] as num?)?.toInt(),
      json['login'] as String,
      json['surname'] as String,
      json['name'] as String,
      json['patronymic'] as String?,
      json['comment'] as String?,
      json['changedPassword'] as bool?,
      (json['restaurantId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'surname': instance.surname,
      'name': instance.name,
      'patronymic': instance.patronymic,
      'comment': instance.comment,
      'changedPassword': instance.changedPassword,
      'restaurantId': instance.restaurantId,
    };
