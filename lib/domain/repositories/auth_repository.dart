// lib/domain/repositories/auth_repository.dart
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String username, String password);
  Future<AuthUser> getCurrentUser();
  Future<void> refreshSession();
  Future<void> logout();
}
