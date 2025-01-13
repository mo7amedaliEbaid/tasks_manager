// test/data/sources/task_remote_data_source_test.dart
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/data/data_sources/task.dart';
import 'package:tasks_manager/data/models/task.dart';


import 'mock_http_client.mocks.dart';

void main() {
  late TaskRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TaskRemoteDataSourceImpl(mockHttpClient);
  });

  final taskJson = {
    "id": 1,
    "title": "Test Task",
    "description": "Description",
    "completed": false,
  };

  final taskModel = TaskModel.fromJson(taskJson);

  group('fetchTasks', () {
    final url = 'https://dummyjson.com/todos?limit=10&skip=0';

    test('should return a list of tasks when the response is 200', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
            (_) async => http.Response(json.encode({"todos": [taskJson]}), 200),
      );

      // Act
      final result = await dataSource.fetchTasks(limit: 10, skip: 0);

      // Assert
      expect(result, [taskModel]);
      verify(mockHttpClient.get(Uri.parse(url)));
    });

    test('should throw an exception when the response is not 200', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
            (_) async => http.Response('Error', 404),
      );

      // Act
      final call = dataSource.fetchTasks;

      // Assert
      expect(() => call(limit: 10, skip: 0), throwsException);
    });
  });
}
