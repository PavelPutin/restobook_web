import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  Restaurant(this.id, this.name, this.legalEntityName, this.inn, this.comment);

  int? id;
  String name;
  String legalEntityName;
  int inn;
  String? comment;

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}