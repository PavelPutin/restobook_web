import '../entities/auth_entity.dart';
import '../utils/utils.dart';
import 'abstract_auth_service.dart';

class MockAuthService extends AbstractAuthService {
  AuthEntity vendorAdmin = AuthEntity("vendor_admin", "qwerty", "vendor_admin");

  @override
  Future<AuthEntity> login(String username, String password) {
    return ConnectionSimulator<AuthEntity>().connect(() {
      if (username == vendorAdmin.login && password == vendorAdmin.password) {
        return vendorAdmin;
      }
      throw Exception("Ошибка в логине или пароле");
    });
  }

  @override
  Future<void> logout() {
    return ConnectionSimulator<void>().connect(() {});
  }
}