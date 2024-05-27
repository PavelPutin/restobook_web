import 'package:get_it/get_it.dart';
import 'package:restobook_web/model/entities/restaurant.dart';
import 'package:restobook_web/model/repository/abstract_restaurant_repository.dart';

import '../utils/utils.dart';
import 'mock_backend.dart';

class MockRestaurantRepository extends AbstractRestaurantRepository {
  final List<Restaurant> _restaurants = GetIt.I<MockBackend>().restaurant;

  @override
  Future<Restaurant> create(Restaurant restaurant) {
    return ConnectionSimulator<Restaurant>().connect(() {
      int maxId = 0;
      for (var r in _restaurants) {
        if (r.id! > maxId) {
          maxId = r.id!;
        }
      }
      restaurant.id = maxId + 1;
      _restaurants.add(restaurant);
      return restaurant;
    });
  }

  @override
  Future<List<Restaurant>> getAll() {
    return ConnectionSimulator<List<Restaurant>>().connect(() => _restaurants);
  }

  @override
  Future<Restaurant> update(Restaurant restaurant) {
    return ConnectionSimulator<Restaurant>().connect(() {
      for (int i = 0; i < _restaurants.length; i++) {
        if (_restaurants[i].id == restaurant.id) {
          _restaurants[i] = restaurant;
          return restaurant;
        }
      }
      throw Exception("Сотрудник не найден");
    });
  }

  @override
  Future<void> delete(Restaurant restaurant) {
    return ConnectionSimulator<void>().connect(() => _restaurants.remove(restaurant));
  }

}