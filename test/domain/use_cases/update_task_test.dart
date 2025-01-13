import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/task_entity.dart';
import 'package:tasks_manager/domain/use_cases/update_task.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late UpdateTask useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = UpdateTask(mockRepository);
  });

  var tTask = Task(
    id: 1,
    title: 152,
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
