// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      (json['id'] as num?)?.toInt(),
      json['name'] as String,
      json['legalEntityName'] as String,
      json['inn'] as String,
      json['comment'] as String?,
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'legalEntityName': instance.legalEntityName,
      'inn': instance.inn,
      'comment': instance.comment,
    };
