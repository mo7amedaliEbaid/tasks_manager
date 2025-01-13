// lib/injection/injection.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:tasks_manager/presentation/blocs/auth/auth_bloc.dart';

import '../data/data_sources/auth_remote_data_source.dart';
import '../data/data_sources/task_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/tasks_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/tasks_repository.dart';
import '../domain/use_cases/add_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../domain/use_cases/get_current_user.dart';
import '../domain/use_cases/get_tasks.dart';
import '../domain/use_cases/log_out.dart';
import '../domain/use_cases/login.dart';
import '../domain/use_cases/refresh_session.dart';
import '../domain/use_cases/update_task.dart';
import '../presentation/blocs/tasks/bloc.dart';
import 'package:http/http.dart' as http;

final GetIt getIt = GetIt.instance;

void init() {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<FlutterSecureStorage>(
      () => FlutterSecureStorage());

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      secureStorage: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => RefreshSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
        refreshSessionUseCase: getIt(),
        logoutUseCase: getIt(),
      ));

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
