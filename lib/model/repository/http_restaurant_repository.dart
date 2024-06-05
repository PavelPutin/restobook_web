import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_web/model/entities/restaurant.dart';
import 'package:restobook_web/model/repository/abstract_restaurant_repository.dart';

import '../service/api_dio.dart';
import '../utils/utils.dart';
import 'mock_backend.dart';

class HttpRestaurantRepository extends AbstractRestaurantRepository {
  final List<Restaurant> _restaurants = GetIt.I<MockBackend>().restaurant;

  Api api = GetIt.I<Api>();
  Logger logger = GetIt.I<Logger>();

  @override
  Future<Restaurant> create(Restaurant restaurant) async {
    try {
      logger.t("Try create restaurant");
      final response = await api.dio.post(
          "/restobook-api/restaurant",
        data: restaurant.toJson()
      );

      Restaurant created = Restaurant.fromJson(response.data);
      return created;
    } on DioException catch (e) {
      logger.e("Can't create restaurant", error: e);
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> getAll() async {
    try {
      logger.t("Try get all restaurants");
      final response = await api.dio.get("/restobook-api/restaurant");

      List<Restaurant> result = [];
      for (var value in response.data) {
        result.add(Restaurant.fromJson(value));
      }
      return result;
    } on DioException catch (e) {
      logger.e("Can't get all restaurants", error: e);
      rethrow;
    }
  }

  @override
  Future<Restaurant> getById(int id) async {
    try {
      logger.t("Try get restaurant $id");
      final response = await api.dio.get("/restobook-api/restaurant/$id");

      Restaurant fetched = Restaurant.fromJson(response.data);
      return fetched;
    } on DioException catch (e) {
      logger.e("Can't get restaurant", error: e);
      rethrow;
    }
  }

  @override
  Future<Restaurant> update(Restaurant restaurant) {
    logger.w("MOCK RESTAURANT UPDATE");
    return ConnectionSimulator<Restaurant>().connect(() {
      for (int i = 0; i < _restaurants.length; i++) {
        if (_restaurants[i].id == restaurant.id) {
          _restaurants[i] = restaurant;
          return restaurant;
        }
      }
      throw Exception("Ресторан не найден");
    });
  }

  @override
  Future<void> delete(Restaurant restaurant) async {
    try {
      logger.t("Try delete restaurant ${restaurant.id}");
      await api.dio.delete("/restobook-api/restaurant/${restaurant.id}");
    } on DioException catch (e) {
      logger.e("Can't get restaurant", error: e);
      rethrow;
    }
  }
}