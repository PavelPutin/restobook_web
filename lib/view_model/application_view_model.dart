import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../model/entities/auth_entity.dart';
import '../model/service/abstract_auth_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  Logger logger = GetIt.I<Logger>();

  AbstractAuthService authService = GetIt.I<AbstractAuthService>();
  AuthEntity? _authorizedUser;

  AuthEntity? get authorizedUser => _authorizedUser;

  bool get authorized => _authorizedUser != null;
  bool get isAdmin => _authorizedUser != null && _authorizedUser!.role == "ROLE_restobook_admin";

  Future<void> login(String username, String password) async {
    // await authService.login(username, password)
    //     .then((value) => _authorizedUser = value);
    try {
      _authorizedUser = await authService.login(username, password);
      notifyListeners();
    } on DioException catch (e) {
      _authorizedUser = null;
      notifyListeners();
      logger.e("Application view model catch dio exception", error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    // await authService.logout();
    _authorizedUser = null;
    notifyListeners();
  }
}