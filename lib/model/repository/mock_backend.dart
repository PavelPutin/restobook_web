import '../entities/employee.dart';
import '../entities/restaurant.dart';

class MockBackend {
  List<Employee> get employee => _employees;
  final List<Employee> _employees = List.from([
    Employee(
        1,
        "frolov_m_vR1",
        "Фролов",
        "Макар",
        null,
        "Лучший сотрудник!",
        true,
        1
    ),
    Employee(
        2,
        "pupkin_v_pR1",
        "Пупкин",
        "Василий",
        "Петрович",
        "стажёр",
        false,
        1
    ),
    Employee(
        3,
        "putin_p_a",
        "Путин",
        "Павел",
        "Александрович",
        "администратор",
        false,
        1
    ),
    Employee(
        4,
        "tokarev",
        "Токарев",
        "Максим",
        "Павлович",
        "администратор",
        false,
        2
    )
  ]);

  List<Restaurant> get restaurant => _restaurant;
  final List<Restaurant> _restaurant = List.from([
    Restaurant(1, "Вкусно и точка точка точка", "ООО Накормим всех", "991154917952", "Хороший ресторан"),
    Restaurant(2, "Ресторан для студентов", "ООО Накормим студентов", "291154917953", null),
  ]);
}