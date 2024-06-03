import '../entities/auth_entity.dart';

abstract class AbstractAuthService {
  Future<AuthEntity?> login(String username, String password);
  Future<void> logout();
}