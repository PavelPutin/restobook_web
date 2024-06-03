import 'package:get_it/get_it.dart';
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
      logger.t("Response data");
      logger.t(response.data);

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
}