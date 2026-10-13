// Unit test for LoginUseCase: verifies it is a thin pass-through to the
// repository. Copy this shape for any new use case in the template.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_template/core/errors/failures.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_template/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  const tEmail = 'demo@demo.com';
  const tPassword = '123456';
  const tUser = UserEntity(
    id: '1',
    name: 'Demo User',
    email: tEmail,
    role: 'admin',
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository: repository);
  });

  test('returns Right(UserEntity) when the repository call succeeds', () async {
    when(() => repository.login(email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Right(tUser));

    final result = await useCase(email: tEmail, password: tPassword);

    expect(result, const Right<Failure, UserEntity>(tUser));
    verify(() => repository.login(email: tEmail, password: tPassword))
        .called(1);
    verifyNoMoreInteractions(repository);
  });

  test('returns Left(Failure) when the repository call fails', () async {
    const failure = AuthFailure(message: 'Invalid credentials');
    when(() => repository.login(email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Left(failure));

    final result = await useCase(email: tEmail, password: tPassword);

    expect(result, const Left<Failure, UserEntity>(failure));
  });
}
