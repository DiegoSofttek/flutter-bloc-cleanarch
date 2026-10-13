// Typed exceptions thrown by the `data` layer (datasources). Repositories
// catch these and convert them into `Failure`s for the `domain` layer.

/// Thrown when the server responds with an error status (4xx, 5xx).
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when reading/writing local storage (e.g. SharedPreferences) fails.
class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there is no network connectivity.
class NetworkException implements Exception {
  final String message;
  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}
