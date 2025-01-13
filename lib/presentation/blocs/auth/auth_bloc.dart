import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../data/data_sources/local/data_base_helper.dart';
import '../../../domain/use_cases/get_current_user.dart';
import '../../../domain/use_cases/log_out.dart';
import '../../../domain/use_cases/login.dart';
import '../../../domain/use_cases/refresh_session.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final RefreshSessionUseCase refreshSessionUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.refreshSessionUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<RefreshSessionEvent>(_onRefreshSession);
  }

  final DatabaseHelper db = DatabaseHelper();

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.username, event.password);
      await db.addUser(event.username, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      await db.getUser(1);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRefreshSession(
      RefreshSessionEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Emit loading state
    try {
      await refreshSessionUseCase(); // Refresh the session
      if (state is Authenticated) {
        // If the current state is Authenticated, re-emit it
        final currentUser = (state as Authenticated).user;
        emit(Authenticated(user: currentUser));
      } else {
        // If not authenticated, emit an error
        emit(
            AuthError(message: 'Session refreshed but user state is invalid.'));
      }
    } catch (e) {
      emit(AuthError(
          message: e.toString())); // Emit error state if refresh fails
    }
  }
}
