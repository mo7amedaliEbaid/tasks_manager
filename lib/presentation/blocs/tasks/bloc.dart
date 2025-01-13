// lib/presentation/bloc/tasks_state.dart
import 'package:equatable/equatable.dart';
import 'package:tasks_manager/presentation/blocs/tasks/states.dart';
import '../../../domain/entities/task.dart';

// lib/presentation/bloc/tasks_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';



import '../../../domain/use_cases/add_task.dart';
import '../../../domain/use_cases/delete_task.dart';
import '../../../domain/use_cases/get_tasks.dart';
import '../../../domain/use_cases/update_task.dart';
import 'events.dart';


class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TasksBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TasksInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TasksLoading());
      try {
        final tasks = await getTasks(limit: event.limit, skip: event.skip);
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError('Failed to load tasks'));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is TasksLoaded) {
          final newTask = await addTask(event.task);
          emit(TasksLoaded([...currentState.tasks, newTask]));
        }
      } catch (e) {
        emit(TasksError('Failed to add task'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is TasksLoaded) {
          final updatedTask = await updateTask(event.task);
          final updatedTasks = currentState.tasks
              .map((task) => task.id == updatedTask.id ? updatedTask : task)
              .toList();
          emit(TasksLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TasksError('Failed to update task'));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is TasksLoaded) {
          await deleteTask(event.taskId);
          final updatedTasks = currentState.tasks
              .where((task) => task.id != event.taskId)
              .toList();
          emit(TasksLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TasksError('Failed to delete task'));
      }
    });
  }
}
