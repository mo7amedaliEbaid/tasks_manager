// lib/domain/usecases/add_task.dart
import '../entities/task.dart';
import '../repositories/task.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<Task> call(Task task) {
    return repository.addTask(task);
  }
}