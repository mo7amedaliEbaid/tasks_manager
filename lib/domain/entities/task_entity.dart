// lib/domain/entities/get_tasks_test.dart
// lib/domain/entities/task_remote_data_source.dart
class Task {
  final int id;
  final int title;
  final String description;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  // Add copyWith method
  Task copyWith({
    int? id,
    int? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

