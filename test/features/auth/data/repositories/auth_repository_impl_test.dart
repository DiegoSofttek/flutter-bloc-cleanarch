// Unit test for AuthRepositoryImpl: verifies exception-to-Failure mapping,
// the one responsibility this layer adds on top of the datasource.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_template/core/errors/exceptions.dart';
import 'package:app_template/core/errors/failures.dart';
import 'package:app_template/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app_template/features/auth/data/models/user_model.dart';
import 'package:app_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app_template/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repository;

  const tEmail = 'demo@demo.com';
  const tPassword = '123456';
  final tUserJson = {
    'user': {
      'id': '1',
      'name': 'Demo User',
      'email': tEmail,
      'role': 'admin',
    },
  };

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  test('returns Right(UserEntity) when the datasource call succeeds',
      () async {
    when(() => remoteDataSource.login(email: tEmail, password: tPassword))
        .thenAnswer((_) async => tUserJson);

    final result = await repository.login(email: tEmail, password: tPassword);

    expect(
      result,
      const Right<Failure, UserEntity>(
        UserModel(id: '1', name: 'Demo User', email: tEmail, role: 'admin'),
      ),
    );
  });

  test('returns Left(ServerFailure) when the datasource throws ServerException',
      () async {
    when(() => remoteDataSource.login(email: tEmail, password: tPassword))
        .thenThrow(const ServerException(message: 'Invalid credentials'));

    final result = await repository.login(email: tEmail, password: tPassword);

    expect(
      result,
      const Left<Failure, UserEntity>(
        ServerFailure(message: 'Invalid credentials'),
      ),
    );
  });
}
