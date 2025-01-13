import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/use_cases/refresh_session.dart';

import '../../../mocks/mocks.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late RefreshSessionUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RefreshSessionUseCase(mockRepository);
  });

  test('should call refreshSession on repository when invoked', () async {
    when(mockRepository.refreshSession()).thenAnswer((_) async => Future.value());

    await useCase();

    verify(mockRepository.refreshSession()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository throws', () async {
    when(mockRepository.refreshSession()).thenThrow(Exception('Error refreshing session'));

    expect(() => useCase(), throwsException);
    verify(mockRepository.refreshSession()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
