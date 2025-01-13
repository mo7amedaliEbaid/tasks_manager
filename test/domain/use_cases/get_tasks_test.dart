// test/domain/usecases/get_tasks_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tasks_manager/domain/entities/task.dart';
import 'package:tasks_manager/domain/use_cases/get_tasks.dart';

import '../respositories/mock_task_repository.mocks.dart';


void main() {
  late GetTasks useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = GetTasks(mockRepository);
  });

  final tasks = [
    Task(id: 1, title: 'Test Task', description: 'Description', completed: false),
  ];

  test('should fetch tasks from the repository', () async {
    // Arrange
    when(mockRepository.getTasks(limit: anyNamed('limit'), skip: anyNamed('skip')))
        .thenAnswer((_) async => tasks);

    // Act
    final result = await useCase(limit: 10, skip: 0);

    // Assert
    expect(result, tasks);
    verify(mockRepository.getTasks(limit: 10, skip: 0));
    verifyNoMoreInteractions(mockRepository);
  });
}
