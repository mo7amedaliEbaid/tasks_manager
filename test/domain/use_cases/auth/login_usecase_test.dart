import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/auth_user.dart';
import 'package:tasks_manager/domain/use_cases/login.dart';

import '../../../mocks/mocks.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const username = 'test_user';
  const password = 'test_pass';
  final mockUser = AuthUser(
    id: 1,
    username: username,
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    gender: 'male',
    image: 'test_image.png',
  );

  test('should return AuthUser on successful login', () async {
    when(mockRepository.login(username, password)).thenAnswer((_) async => mockUser);

    final result = await useCase(username, password);

    expect(result, mockUser);
    verify(mockRepository.login(username, password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
