

import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';

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
  final String localTitle;

  const AddTaskEvent(this.task, this.localTitle);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TasksEvent {
  final Task task;
  final int id;
  final String localTitle;

  const UpdateTaskEvent(this.task, this.id, this.localTitle);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TasksEvent {
  final int taskId;
  final int localId;

  const DeleteTaskEvent(this.taskId, this.localId);

  @override
  List<Object?> get props => [taskId];
}
