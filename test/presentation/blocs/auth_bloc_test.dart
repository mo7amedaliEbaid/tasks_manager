import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_manager/domain/entities/auth_user.dart';
import 'package:tasks_manager/domain/use_cases/get_current_user.dart';
import 'package:tasks_manager/domain/use_cases/log_out.dart';
import 'package:tasks_manager/domain/use_cases/login.dart';
import 'package:tasks_manager/domain/use_cases/refresh_session.dart';
import 'package:tasks_manager/presentation/blocs/auth/auth_bloc.dart';
import 'package:tasks_manager/presentation/blocs/auth/auth_events.dart';
import 'package:tasks_manager/presentation/blocs/auth/auth_states.dart';

import '../../mocks/mocks.mocks.dart';



void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late RefreshSessionUseCase refreshSessionUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
    logoutUseCase = LogoutUseCase(mockAuthRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(mockAuthRepository);
    refreshSessionUseCase = RefreshSessionUseCase(mockAuthRepository);

    authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      refreshSessionUseCase: refreshSessionUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
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

  group('AuthBloc Tests', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when LoginEvent is successful',
      build: () {
        when(mockAuthRepository.login(any, any))
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginEvent(username: 'test_user', password: 'password')),
      expect: () => [
        AuthLoading(),
        Authenticated(user: mockUser),
      ],
      verify: (_) {
        verify(mockAuthRepository.login('test_user', 'password')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginEvent fails',
      build: () {
        when(mockAuthRepository.login(any, any))
            .thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginEvent(username: 'test_user', password: 'wrong_password')),
      expect: () => [
        AuthLoading(),
        AuthError(message: 'Exception: Login failed'),
      ],
      verify: (_) {
        verify(mockAuthRepository.login('test_user', 'wrong_password')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when GetCurrentUserEvent is successful',
      build: () {
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(GetCurrentUserEvent()),
      expect: () => [
        AuthLoading(),
        Authenticated(user: mockUser),
      ],
      verify: (_) {
        verify(mockAuthRepository.getCurrentUser()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when GetCurrentUserEvent fails',
      build: () {
        when(mockAuthRepository.getCurrentUser())
            .thenThrow(Exception('Failed to fetch user'));
        return authBloc;
      },
      act: (bloc) => bloc.add(GetCurrentUserEvent()),
      expect: () => [
        AuthLoading(),
        AuthError(message: 'Exception: Failed to fetch user'),
      ],
      verify: (_) {
        verify(mockAuthRepository.getCurrentUser()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when LogoutEvent is successful',
      build: () {
        when(mockAuthRepository.logout()).thenAnswer((_) async => Future.value());
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
      verify: (_) {
        verify(mockAuthRepository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when RefreshSessionEvent fails',
      build: () {
        when(mockAuthRepository.refreshSession())
            .thenThrow(Exception('Failed to refresh session'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RefreshSessionEvent()),
      expect: () => [
        AuthLoading(),
        AuthError(message: 'Exception: Failed to refresh session'),
      ],
      verify: (_) {
        verify(mockAuthRepository.refreshSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when RefreshSessionEvent is successful',
      build: () {
        when(mockAuthRepository.refreshSession())
            .thenAnswer((_) async => Future.value());
        return authBloc;
      },
      seed: () => Authenticated(user: mockUser), // Start with Authenticated state
      act: (bloc) => bloc.add(RefreshSessionEvent()),
      expect: () => [
        AuthLoading(),
        Authenticated(user: mockUser), // Re-emit the same state after refresh
      ],
      verify: (_) {
        verify(mockAuthRepository.refreshSession()).called(1);
      },
    );
  });
}
