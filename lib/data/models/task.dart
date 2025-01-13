// lib/data/models/task_model.dart
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int id,
    required String title,
    required String description,
    required bool completed,
  }) : super(
    id: id,
    title: title,
    description: description,
    completed: completed,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completed == completed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    description.hashCode ^
    completed.hashCode;
  }
}
