// lib/domain/usecases/add_task.dart
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<Task> call(Task task) {
    return repository.addTask(task);
  }
}