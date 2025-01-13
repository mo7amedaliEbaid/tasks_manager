import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/data/models/auth_user_model.dart';
import 'package:tasks_manager/data/repositories/auth_repository_impl.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSecureStorage = MockFlutterSecureStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      secureStorage: mockSecureStorage,
    );
  });

  group('login', () {
    const username = 'test_user';
    const password = 'test_pass';
    final mockUser = AuthUserModel(
      id: 1,
      username: username,
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      gender: 'male',
      image: 'test_image.png',
    );

    test('should save tokens and return AuthUser on successful login', () async {
      when(mockRemoteDataSource.login(username, password))
          .thenAnswer((_) async => mockUser);

      final result = await repository.login(username, password);

      verify(mockSecureStorage.write(key: 'accessToken', value: anyNamed('value'))).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: anyNamed('value'))).called(1);

      expect(result, mockUser);
    });
  });

  group('logout', () {
    test('should clear tokens from secure storage', () async {
      await repository.logout();

      verify(mockSecureStorage.delete(key: 'accessToken')).called(1);
      verify(mockSecureStorage.delete(key: 'refreshToken')).called(1);
    });
  });

  group('getCurrentUser', () {
    const accessToken = 'test_access_token';
    final mockUser = AuthUserModel(
      id: 1,
      username: 'test_user',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      gender: 'male',
      image: 'test_image.png',
    );

    test('should fetch and return AuthUser when access token is present', () async {
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => accessToken);
      when(mockRemoteDataSource.getCurrentUser(accessToken))
          .thenAnswer((_) async => mockUser);

      final result = await repository.getCurrentUser();

      verify(mockSecureStorage.read(key: 'accessToken')).called(1);
      verify(mockRemoteDataSource.getCurrentUser(accessToken)).called(1);
      expect(result, mockUser);
    });

    test('should throw an exception when access token is not found', () async {
      when(mockSecureStorage.read(key: 'accessToken')).thenAnswer((_) async => null);

      expect(() => repository.getCurrentUser(), throwsException);

      verify(mockSecureStorage.read(key: 'accessToken')).called(1);
      verifyNever(mockRemoteDataSource.getCurrentUser(any));
    });
  });

  group('refreshSession', () {
    const refreshToken = 'test_refresh_token';
    const newAccessToken = 'new_access_token';
    const newRefreshToken = 'new_refresh_token';

    test('should refresh session and save new tokens to secure storage', () async {
      when(mockSecureStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => refreshToken);
      when(mockRemoteDataSource.refreshSession(refreshToken))
          .thenAnswer((_) async => {
        'accessToken': newAccessToken,
        'refreshToken': newRefreshToken,
      });

      await repository.refreshSession();

      verify(mockSecureStorage.read(key: 'refreshToken')).called(1);
      verify(mockRemoteDataSource.refreshSession(refreshToken)).called(1);
      verify(mockSecureStorage.write(key: 'accessToken', value: newAccessToken)).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: newRefreshToken)).called(1);
    });

    test('should throw an exception when refresh token is not found', () async {
      when(mockSecureStorage.read(key: 'refreshToken')).thenAnswer((_) async => null);

      expect(() => repository.refreshSession(), throwsException);

      verify(mockSecureStorage.read(key: 'refreshToken')).called(1);
      verifyNever(mockRemoteDataSource.refreshSession(any));
    });
  });
}
