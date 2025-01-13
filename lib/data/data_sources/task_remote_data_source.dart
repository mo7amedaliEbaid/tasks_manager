// lib/data/sources/task_remote_data_source.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks({required int limit, required int skip});
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> editTask(TaskModel task);
  Future<void> deleteTask(int id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/todos';

  TaskRemoteDataSourceImpl(this.client);

  @override
  Future<List<TaskModel>> fetchTasks({required int limit, required int skip}) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&skip=$skip'));
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final data = json.decode(response.body)['todos'] as List;
      log(data.toString());
      return data.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  @override
  Future<TaskModel> editTask(TaskModel task) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit task');
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
