// lib/data/repositories/task_repository_impl.dart
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../data_sources/task_remote_data_source.dart';
import '../models/task_model.dart';

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
