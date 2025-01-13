// lib/domain/usecases/get_tasks_test.dart
import '../entities/task.dart';
import '../repositories/task.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call({required int limit, required int skip}) {
    return repository.getTasks(limit: limit, skip: skip);
  }
}




