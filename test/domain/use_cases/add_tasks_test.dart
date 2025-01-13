// test/domain/usecases/add_task_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/task_entity.dart';
import 'package:tasks_manager/domain/use_cases/add_task.dart';

import '../../mocks/mocks.mocks.dart';


void main() {
  late AddTask useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = AddTask(mockRepository);
  });

  final task = Task(id: 1, title: 152, description: 'Description', completed: false);

  test('should add a task to the repository', () async {
    // Arrange
    when(mockRepository.addTask(task)).thenAnswer((_) async => task);

    // Act
    final result = await useCase(task);

    // Assert
    expect(result, task);
    verify(mockRepository.addTask(task));
    verifyNoMoreInteractions(mockRepository);
  });
}
