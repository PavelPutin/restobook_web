import 'package:get_it/get_it.dart';

import '../entities/employee.dart';
import '../utils/utils.dart';
import 'abstract_employee_repository.dart';
import 'mock_backend.dart';

class MockEmployeeRepository extends AbstractEmployeeRepository {
  final List<Employee> _employees = GetIt.I<MockBackend>().employee;

  @override
  Future<Employee> create(Employee employee) {
    return ConnectionSimulator<Employee>().connect(() {
      int maxId = 0;
      for (var e in _employees) {
        if (e.id! > maxId) {
          maxId = e.id!;
        }
      }
      employee.id = maxId + 1;
      _employees.add(employee);
      return employee;
    });
  }

  @override
  Future<List<Employee>> getAll() {
    return ConnectionSimulator<List<Employee>>().connect(() => _employees);
  }

  @override
  Future<Employee> update(Employee employee) {
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