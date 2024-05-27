import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  Employee(
      this.id,
      this.login,
      this.surname,
      this.name,
      this.patronymic,
      this.comment,
      this.changedPassword,
      this.restaurantId
      );

  int? id;
  String login;
  String surname;
  String name;
  String? patronymic;
  String? comment;
  bool? changedPassword;
  int? restaurantId;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  String get shortFullName => "$surname ${name[0]}.${patronymic != null ? "${patronymic![0]}." : ""}";
}