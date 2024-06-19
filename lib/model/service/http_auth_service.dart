import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/auth_entity.dart';
import 'abstract_auth_service.dart';
import 'api_dio.dart';

class HttpAuthService extends AbstractAuthService {
  Api api = GetIt.I<Api>();
  Logger logger = GetIt.I<Logger>();

  @override
  Future<AuthEntity?> login(String username, String password) async {
    logger.t("Try login for $username $password");
    try {
      var response = await api.dio.post(
          "/realms/master/protocol/openid-connect/token",
          data: {
            "grant_type": "password",
            "client_id": Api.clientId,
            "username": username,
            "password": password,
          },
          options: dio.Options(
              contentType: dio.Headers.formUrlEncodedContentType)
      );

      logger.t("Response status is ${response.statusCode}");

      if (response.statusCode! == 200) {
        var accessToken = response.data["access_token"];
        logger.t("Get accessToken");
        SharedPreferences secureStorage = await api.secureStorageFuture;
        secureStorage.setString(Api.accessTokenKey, accessToken);
        logger.t("Save accessToken");
        var refreshToken = response.data["refresh_token"];
        logger.t("Get refreshToken");
        secureStorage.setString(Api.refreshTokenKey, refreshToken);
        logger.t("Save refreshToken");
        return AuthEntity(username, "", "vendor_admin");
      }
    } on dio.DioException catch (e) {
      logger.e("Catch DioException", error: e);
      rethrow;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    logger.t("Process logout");
    SharedPreferences secureStorage = await api.secureStorageFuture;
    secureStorage.remove(Api.accessTokenKey);
    secureStorage.remove(Api.refreshTokenKey);
  }

  @override
  Future<AuthEntity?> getAuthorized() async {
    try {
      SharedPreferences secureStorage = await api.secureStorageFuture;
      final refreshToken = secureStorage.getString(Api.refreshTokenKey);

      if (refreshToken == null) {
        return null;
      }

      var response = await api.dio.post(
          "/realms/master/protocol/openid-connect/token",
          data: {
            'grant_type': 'refresh_token',
            'client_id': Api.clientId,
            'refresh_token': refreshToken
          },
          options: dio.Options(
              contentType: dio.Headers.formUrlEncodedContentType)
      );

      if (response.statusCode == null ||
          response.statusCode! ~/ 100 != 2) {
        logger.e("Error get refresh token");
        throw dio.DioException(requestOptions: response.requestOptions);
      }

      logger.t("Get refresh token");
      var accessToken = response.data['access_token'];
      secureStorage.setString(Api.accessTokenKey, accessToken);
      logger.t("Set accessToken");
      var newRefreshToken = response.data['refresh_token'];
      await secureStorage.setString(Api.refreshTokenKey, newRefreshToken);
      logger.t("Set refreshToken");
      logger.t("Finish process anauthorized request");

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      final username = decodedToken["preferred_username"];
      return AuthEntity(username, "", "vendor_admin");
    } catch (e) {
      logger.e("Can't get authorized");
      rethrow;
    }
  }
}