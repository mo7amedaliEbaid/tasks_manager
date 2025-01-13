// lib/data/repositories/task_repository_impl.dart
import '../../domain/entities/task.dart';
import '../../domain/repositories/task.dart';
import '../data_sources/task.dart';
import '../models/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Task>> getTasks({required int limit, required int skip}) async {
    return remoteDataSource.fetchTasks(limit: limit, skip: skip);
  }

  @override
  Future<Task> addTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
    );
    return remoteDataSource.createTask(taskModel);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
    );
    return remoteDataSource.editTask(taskModel);
  }

  @override
  Future<void> deleteTask(int id) async {
    await remoteDataSource.deleteTask(id);
  }
}
