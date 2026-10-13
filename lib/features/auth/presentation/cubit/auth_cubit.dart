// Presentation-layer glue: calls LoginUseCase and emits typed AuthStates;
// persists the token so GoRouter's redirect can read it on next launch.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

/// Key used to persist the JWT token in SharedPreferences.
const String kAuthTokenKey = 'auth_token';

/// Cubit responsible for the authentication flow.
/// Calls [LoginUseCase] and emits typed states.
/// Persists the token after a successful login.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(const AuthInitial());

  /// Starts the login process with [email] and [password].
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await loginUseCase(email: email, password: password);

    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        // Persist token in SharedPreferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kAuthTokenKey, 'fake-jwt-token-abc123');
        emit(AuthSuccess(user));
      },
    );
  }

  /// Logs out by removing the persisted token.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kAuthTokenKey);
    emit(const AuthInitial());
  }
}
