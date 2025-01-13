import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/use_cases/delete_task.dart';

import '../../mocks/mocks.mocks.dart';



void main() {
  late DeleteTask useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = DeleteTask(mockRepository);
  });

  const tTaskId = 1;

  test('should delete the task from the repository', () async {
    // Arrange
    when(mockRepository.deleteTask(tTaskId)).thenAnswer((_) async => Future.value());

    // Act
    await useCase(tTaskId);

    // Assert
    verify(mockRepository.deleteTask(tTaskId));
    verifyNoMoreInteractions(mockRepository);
  });
}
