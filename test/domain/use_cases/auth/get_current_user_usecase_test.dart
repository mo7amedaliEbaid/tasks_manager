import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/auth_user.dart';
import 'package:tasks_manager/domain/use_cases/get_current_user.dart';

import '../../../mocks/mocks.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUserUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  final mockUser = AuthUser(
    id: 1,
    username: 'test_user',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    gender: 'male',
    image: 'test_image.png',
  );

  test('should return AuthUser from repository when called', () async {
    when(mockRepository.getCurrentUser()).thenAnswer((_) async => mockUser);

    final result = await useCase();

    expect(result, mockUser);
    verify(mockRepository.getCurrentUser()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository throws', () async {
    when(mockRepository.getCurrentUser()).thenThrow(Exception('Error fetching user'));

    expect(() => useCase(), throwsException);
    verify(mockRepository.getCurrentUser()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
