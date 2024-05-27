import 'package:restobook_web/model/entities/restaurant.dart';

abstract class AbstractRestaurantRepository {
  Future<List<Restaurant>> getAll();
  Future<Restaurant> getById(int id);
  Future<Restaurant> create(Restaurant restaurant);
  Future<Restaurant> update(Restaurant restaurant);
  Future<void> delete(Restaurant restaurant);
}