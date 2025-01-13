

import 'package:equatable/equatable.dart';

import '../../../domain/entities/task.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TasksEvent {
  final int limit;
  final int skip;

  const LoadTasks(this.limit, this.skip);

  @override
  List<Object?> get props => [limit, skip];
}

class AddTaskEvent extends TasksEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TasksEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TasksEvent {
  final int taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
