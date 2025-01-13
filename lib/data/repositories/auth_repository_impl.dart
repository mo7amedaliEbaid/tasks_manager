// lib/data/repositories/auth_repository_impl.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<AuthUser> login(String username, String password) async {
    final user = await remoteDataSource.login(username, password);
    final tokens = {
      'accessToken': 'SAMPLE_ACCESS_TOKEN',
      'refreshToken': 'SAMPLE_REFRESH_TOKEN'
    };

    // Save tokens to secure storage
    await secureStorage.write(key: 'accessToken', value: tokens['accessToken']);
    await secureStorage.write(
        key: 'refreshToken', value: tokens['refreshToken']);
    return user;
  }
  @override
  Future<AuthUser> getCurrentUser() async {
    final accessToken = await secureStorage.read(key: 'accessToken');
    if (accessToken == null) throw Exception('Access token not found');

    return await remoteDataSource.getCurrentUser(accessToken);
  }

  @override
  Future<void> refreshSession() async {
    final refreshToken = await secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) throw Exception('Refresh token not found');

    final tokens = await remoteDataSource.refreshSession(refreshToken);

    // Save new tokens to secure storage
    await secureStorage.write(key: 'accessToken', value: tokens['accessToken']);
    await secureStorage.write(key: 'refreshToken', value: tokens['refreshToken']);
  }

  @override
  Future<void> logout() async {
    // Clear tokens from secure storage
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
  }

}