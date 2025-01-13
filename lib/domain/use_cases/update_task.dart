import '../entities/task.dart';
import '../repositories/task.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Task> call(Task task) {
    return repository.updateTask(task);
  }
}