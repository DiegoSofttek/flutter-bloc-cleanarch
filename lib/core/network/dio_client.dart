// Thin wrapper around Dio with shared config/interceptors, plus a mock
// interceptor so the template's example feature works with zero backend.
// Delete `_MockInterceptor` once a real API is wired up.

import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../errors/exceptions.dart';

/// Shared Dio instance with base config and logging/mock interceptors.
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.addAll([
      _MockInterceptor(),
      _AppLogInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  /// Attaches a bearer token to all subsequent requests.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Removes any previously attached bearer token.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

/// Logs each request/response/error for local debugging.
class _AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] --> ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] <-- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] ERROR ${err.response?.statusCode}: ${err.message}');
    handler.next(err);
  }
}

/// Fakes the auth backend so the template runs without a real API.
/// Demo credentials: demo@example.com / 123456.
class _MockInterceptor extends Interceptor {
  static const String _validEmail = 'demo@example.com';
  static const String _validPassword = '123456';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (options.path == ApiEndpoints.login && options.method == 'POST') {
      _handleLogin(options, handler);
      return;
    }

    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 404,
          data: {'message': 'Endpoint not found'},
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  }

  void _handleLogin(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final data = options.data as Map<String, dynamic>? ?? {};
    final email = data['email'] as String? ?? '';
    final password = data['password'] as String? ?? '';

    if (email == _validEmail && password == _validPassword) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'token': 'fake-jwt-token-abc123',
            'user': {
              'id': '1',
              'name': 'Demo User',
              'email': _validEmail,
              'role': 'admin',
            },
          },
        ),
      );
    } else {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }
}

/// Maps a [DioException] into a typed [ServerException] with a friendly
/// message, so upper layers never deal with Dio-specific types.
ServerException dioExceptionToServerException(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return const ServerException(
      message: 'The request took too long. Please try again.',
      statusCode: 408,
    );
  }

  final statusCode = e.response?.statusCode;
  final data = e.response?.data;
  final message = (data is Map && data['message'] != null)
      ? data['message'].toString()
      : e.message ?? 'Unexpected network error.';

  return ServerException(message: message, statusCode: statusCode);
}
