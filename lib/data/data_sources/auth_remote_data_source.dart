// lib/data/data_sources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(String username, String password);

  Future<AuthUserModel> getCurrentUser(String accessToken);

  Future<Map<String, String>> refreshSession(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/auth';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthUserModel> login(String username, String password) async {
    username = "emilys";
    password = "emilyspass";
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthUserModel.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<AuthUserModel> getCurrentUser(String accessToken) async {
    final response = await client.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthUserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  @override
  Future<Map<String, String>> refreshSession(String refreshToken) async {
    final response = await client.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } else {
      throw Exception('Failed to refresh session');
    }
  }
}
