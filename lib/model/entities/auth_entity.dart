import 'package:json_annotation/json_annotation.dart';

import 'employee.dart';

part 'auth_entity.g.dart';

@JsonSerializable()
class AuthEntity {
  AuthEntity(
      this.employee,
      this.password,
      this.role,
      );
  Employee employee;
  String password;
  String role;

  factory AuthEntity.fromJson(Map<String, dynamic> json) => _$AuthEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AuthEntityToJson(this);
}