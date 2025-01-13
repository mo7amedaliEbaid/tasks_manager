// lib/domain/repositories/task_repository.dart
import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({required int limit, required int skip});
  Future<Task> addTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(int id);
}
