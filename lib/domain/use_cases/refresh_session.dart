// lib/domain/usecases/refresh_session_usecase.dart
import '../repositories/auth_repository.dart';

class RefreshSessionUseCase {
  final AuthRepository repository;

  RefreshSessionUseCase(this.repository);

  Future<void> call() {
    return repository.refreshSession();
  }
}
