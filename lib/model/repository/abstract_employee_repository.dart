import '../entities/employee.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAllByRestaurant(int restaurantId);
  Future<Employee> create(Employee employee);
  Future<Employee> update(Employee employee);
}