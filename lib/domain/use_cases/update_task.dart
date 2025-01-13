import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Task> call(Task task) {
    return repository.updateTask(task);
  }
}