import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:restobook_web/model/entities/restaurant.dart';
import 'package:restobook_web/model/repository/abstract_restaurant_repository.dart';

import '../model/entities/employee.dart';
import '../model/repository/abstract_employee_repository.dart';

class RestaurantViewModel extends ChangeNotifier {
  AbstractRestaurantRepository restaurantRepository = GetIt.I<AbstractRestaurantRepository>();
  AbstractEmployeeRepository employeeRepository = GetIt.I<AbstractEmployeeRepository>();

  List<Restaurant> _restaurants = [];
  UnmodifiableListView<Restaurant> get restaurants => UnmodifiableListView(_restaurants);

  Restaurant? _activeRestaurant;
  Restaurant? get activeRestaurant => _activeRestaurant;
  set activeRestaurant(Restaurant? restaurant) => _activeRestaurant = restaurant;

  final List<Employee> _activeRestaurantEmployees = [];
  UnmodifiableListView<Employee> get activeRestaurantEmployees =>
      UnmodifiableListView(_activeRestaurantEmployees);

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL EMPLOYEES
    _restaurants = await restaurantRepository.getAll();
    notifyListeners();
  }

  Future<void> loadActiveRestaurant(int restaurantId) async {
    // TODO: ADD HTTP REQUEST TO GET EMPLOYEES BY ID
    activeRestaurant = await restaurantRepository.getById(restaurantId);
    _activeRestaurantEmployees.clear();
    _activeRestaurantEmployees.addAll(await employeeRepository.getAllByRestaurant(restaurantId));
    notifyListeners();
  }

  Future<void> add(Restaurant restaurant) async {
    // TODO: ADD HTTP REQUEST TO CREATE EMPLOYEE
    activeRestaurant = await restaurantRepository.create(restaurant);
    notifyListeners();
  }

  Future<void> update(Restaurant restaurant) async {
    // TODO: ADD HTTP REQUEST TO UPDATE EMPLOYEE
    activeRestaurant = await restaurantRepository.update(restaurant);
    notifyListeners();
  }

  Future<void> delete(Restaurant restaurant) async {
    // TODO: ADD HTTP REQUEST TO DELETE EMPLOYEE
    await restaurantRepository.delete(restaurant);
    notifyListeners();
  }
}