import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../entities/employee.dart';
import '../service/api_dio.dart';
import '../utils/utils.dart';
import 'abstract_employee_repository.dart';
import 'mock_backend.dart';

class HttpEmployeeRepository extends AbstractEmployeeRepository {
  final List<Employee> _employees = GetIt.I<MockBackend>().employee;

  Api api = GetIt.I<Api>();
  Logger logger = GetIt.I<Logger>();

  @override
  Future<Employee> create(int restaurantId, Employee employee, String password, String role) async {
    try {
      logger.t("Try create employee");
      var data = employee.toJson();
      data["password"] = password;
      data["role"] = role;
      final response = await api.dio.post(
          "/restobook-api/restaurant/$restaurantId/employee",
          data: data
      );

      Employee created = Employee.fromJson(response.data);
      return created;
    } on DioException catch (e) {
      logger.e("Can't create employee", error: e);
      if (e.response != null && e.response!.statusCode == 400) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data["messages"] is List<dynamic>) {
          throw "Login must be unique";
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<Employee>> getAllByRestaurant(int restaurantId) async {
    try {
      logger.t("Try get all employees");
      final response = await api.dio.get("/restobook-api/restaurant/$restaurantId/employee");

      List<Employee> result = [];
      for (var value in response.data) {
        result.add(Employee.fromJson(value));
      }
      return result;
    } on DioException catch (e) {
      logger.e("Can't get all employees", error: e);
      rethrow;
    }
  }

  @override
  Future<Employee> update(Employee employee) {
    logger.w("MOCK EMPLOYEE UPDATE");
    return ConnectionSimulator<Employee>().connect(() {
      for (int i = 0; i < _employees.length; i++) {
        if (_employees[i].id == employee.id) {
          _employees[i] = employee;
          return employee;
        }
      }
      throw Exception("Сотрудник не найден");
    });
  }

}