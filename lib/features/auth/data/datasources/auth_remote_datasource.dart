// Only component allowed to talk to Dio directly for auth. Throws typed
// exceptions on failure — converting those to Failures is the repository's job.

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for authentication.
/// Only interacts with Dio; throws [ServerException] on failure.
/// Never returns Failures (that is the repository's responsibility).
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  const AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      return data;
    } on DioException catch (e) {
      throw dioExceptionToServerException(e);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
