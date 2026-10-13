// Abstract contract for authentication. `domain` depends only on this
// interface; the concrete implementation lives in `data`.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Abstract contract for the authentication repository.
/// The domain layer only knows this interface; the implementation lives in data.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
}
