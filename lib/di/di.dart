// lib/injection/injection.dart
import 'package:get_it/get_it.dart';

import '../data/data_sources/task.dart';
import '../data/repositories/task_impl.dart';
import '../domain/repositories/task.dart';
import '../domain/use_cases/add_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../domain/use_cases/get_tasks.dart';
import '../domain/use_cases/update_task.dart';
import '../presentation/blocs/tasks/bloc.dart';
import 'package:http/http.dart' as http;

final GetIt getIt = GetIt.instance;

void init() {
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Data Sources
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(getIt()),
  );

  // Repository Layer
  getIt
      .registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(getIt()));

  // Use Cases
  getIt.registerLazySingleton<GetTasks>(() => GetTasks(getIt()));
  getIt.registerLazySingleton<AddTask>(() => AddTask(getIt()));
  getIt.registerLazySingleton<UpdateTask>(() => UpdateTask(getIt()));
  getIt.registerLazySingleton<DeleteTask>(() => DeleteTask(getIt()));

  // Bloc
  getIt.registerFactory<TasksBloc>(() => TasksBloc(
        getTasks: getIt(),
        addTask: getIt(),
        updateTask: getIt(),
        deleteTask: getIt(),
      ));
}
