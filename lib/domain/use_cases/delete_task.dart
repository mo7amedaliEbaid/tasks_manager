import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(int id) {
    return repository.deleteTask(id);
  }
}
