import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/task_entity.dart';
import 'package:tasks_manager/domain/use_cases/add_task.dart';
import 'package:tasks_manager/domain/use_cases/delete_task.dart';
import 'package:tasks_manager/domain/use_cases/get_tasks.dart';
import 'package:tasks_manager/domain/use_cases/update_task.dart';
import 'package:tasks_manager/presentation/blocs/tasks/bloc.dart';
import 'package:tasks_manager/presentation/blocs/tasks/events.dart';
import 'package:tasks_manager/presentation/blocs/tasks/states.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late TasksBloc bloc;
  late MockTaskRepository mockRepository;
  late GetTasks getTasks;
  late AddTask addTask;
  late UpdateTask updateTask;
  late DeleteTask deleteTask;

  setUp(() {
    mockRepository = MockTaskRepository();
    getTasks = GetTasks(mockRepository);
    addTask = AddTask(mockRepository);
    updateTask = UpdateTask(mockRepository);
    deleteTask = DeleteTask(mockRepository);

    bloc = TasksBloc(
      getTasks: getTasks,
      addTask: addTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
    );
  });

  var tTask =
      Task(id: 1, title: 152, description: 'Test Desc', completed: false);

  group('TasksBloc', () {
    blocTest<TasksBloc, TasksState>(
      'emits [TasksError] when LoadTasks fails',
      build: () {
        when(mockRepository.getTasks(
                limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenThrow(Exception());
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTasks(10, 0)),
      expect: () => [TasksLoading(), TasksError('Failed to load tasks')],
    );
  });
}
