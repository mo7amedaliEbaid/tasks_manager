
import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task>? tasks;
  final List<Map<String, dynamic>> localTasks;

  const TasksLoaded(this.tasks, this.localTasks);

  @override
  List<Object?> get props => [tasks,localTasks];
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}
