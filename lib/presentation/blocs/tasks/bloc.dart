import 'package:tasks_manager/presentation/blocs/tasks/states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_sources/local/data_base_helper.dart';
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
  final DatabaseHelper db = DatabaseHelper();

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
        final localTasks = await db.getNotes();
        emit(
          TasksLoaded(
            tasks,
            localTasks,
          ),
        );
      } catch (e) {
        emit(TasksError('Failed to load tasks'));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is TasksLoaded) {
          final newTask = await addTask(event.task);

          await db.addNote(event.localTitle, event.task.description);
          final localTasks = await db.getNotes();
          emit(TasksLoaded([...currentState.tasks, newTask], localTasks));
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
          await db.updateNote(
              event.id, event.localTitle, event.task.description);
          final localTasks = await db.getNotes();
          emit(TasksLoaded(updatedTasks, localTasks));
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
          await db.deleteNote(event.localId);
          final localTasks = await db.getNotes();
          emit(TasksLoaded(updatedTasks, localTasks));
        }
      } catch (e) {
        emit(TasksError('Failed to delete task'));
      }
    });
  }
}
