import '../entities/employee.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAll();
  Future<Employee> create(Employee employee);
  Future<Employee> update(Employee employee);
}