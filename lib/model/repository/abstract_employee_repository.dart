import '../entities/employee.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAllByRestaurant(int restaurantId);
  Future<Employee> create(int restaurantId, Employee employee, String password, String role);
  Future<Employee> update(Employee employee);
}