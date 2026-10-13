// Use case for the login flow — the smallest unit of business logic the
// presentation layer calls, isolated so it can be unit-tested on its own.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: log in a user.
/// Single responsibility: delegate the call to the repository and propagate the result.
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
