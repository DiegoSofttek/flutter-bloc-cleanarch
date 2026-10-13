// Cubit test using bloc_test: verifies the emitted state sequence for both
// the success and failure paths of AuthCubit.login.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_template/core/errors/failures.dart' as failures;
import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/usecases/login_usecase.dart';
import 'package:app_template/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:app_template/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;

  const tEmail = 'demo@demo.com';
  const tPassword = '123456';
  const tUser = UserEntity(
    id: '1',
    name: 'Demo User',
    email: tEmail,
    role: 'admin',
  );

  setUp(() {
    loginUseCase = MockLoginUseCase();
    // AuthCubit.login persists the token via SharedPreferences.
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthSuccess] when login succeeds',
    build: () {
      when(() => loginUseCase(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Right(tUser));
      return AuthCubit(loginUseCase: loginUseCase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    expect: () => const [AuthLoading(), AuthSuccess(tUser)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] when login fails',
    build: () {
      when(() => loginUseCase(email: tEmail, password: tPassword))
          .thenAnswer(
        (_) async =>
            const Left(failures.AuthFailure(message: 'Invalid credentials')),
      );
      return AuthCubit(loginUseCase: loginUseCase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    expect: () => const [AuthLoading(), AuthFailure('Invalid credentials')],
  );
}
