import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tasks_manager/data/data_sources/auth_remote_data_source.dart';
import 'package:tasks_manager/data/models/auth_user_model.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(client: mockHttpClient);
  });

  const baseUrl = 'https://dummyjson.com/auth';

  group('login', () {
    const username = 'test_user';
    const password = 'test_pass';
    const mockResponse = {
      'id': 1,
      'username': 'test_user',
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'gender': 'male',
      'image': 'test_image.png'
    };

    test('should return AuthUserModel on successful login', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await remoteDataSource.login(username, password);

      expect(result, isA<AuthUserModel>());
      expect(result.username, mockResponse['username']);
    });

    test('should throw an exception on login failure', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(() => remoteDataSource.login(username, password), throwsException);
    });
  });

  group('getCurrentUser', () {
    const accessToken = 'test_access_token';
    const mockResponse = {
      'id': 1,
      'username': 'test_user',
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'gender': 'male',
      'image': 'test_image.png'
    };

    test('should return AuthUserModel on successful fetch', () async {
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await remoteDataSource.getCurrentUser(accessToken);

      expect(result, isA<AuthUserModel>());
      expect(result.username, mockResponse['username']);
    });

    test('should throw an exception when fetching user fails', () async {
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => remoteDataSource.getCurrentUser(accessToken), throwsException);
    });
  });

  group('refreshSession', () {
    const refreshToken = 'test_refresh_token';
    const mockResponse = {
      'accessToken': 'new_access_token',
      'refreshToken': 'new_refresh_token'
    };

    test('should return new tokens on successful session refresh', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await remoteDataSource.refreshSession(refreshToken);

      expect(result, isA<Map<String, String>>());
      expect(result['accessToken'], mockResponse['accessToken']);
      expect(result['refreshToken'], mockResponse['refreshToken']);
    });

    test('should throw an exception on refresh session failure', () async {
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(() => remoteDataSource.refreshSession(refreshToken), throwsException);
    });
  });
}
