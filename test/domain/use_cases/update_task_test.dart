import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/task.dart';
import 'package:tasks_manager/domain/use_cases/update_task.dart';

import '../respositories/mock_task_repository.mocks.dart';

void main() {
  late UpdateTask useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = UpdateTask(mockRepository);
  });

  var tTask = Task(
    id: 1,
    title: 'Updated Task',
    description: 'Updated Description',
    completed: true,
  );

  test('should update the task in the repository', () async {
    // Arrange
    when(mockRepository.updateTask(tTask)).thenAnswer((_) async => tTask);

    // Act
    final result = await useCase(tTask);

    // Assert
    expect(result, tTask);
    verify(mockRepository.updateTask(tTask));
    verifyNoMoreInteractions(mockRepository);
  });
}
