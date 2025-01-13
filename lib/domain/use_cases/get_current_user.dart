// lib/domain/usecases/get_current_user_usecase.dart
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<AuthUser> call() {
    return repository.getCurrentUser();
  }
}
