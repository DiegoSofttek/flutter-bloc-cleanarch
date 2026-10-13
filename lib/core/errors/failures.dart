// Typed failure hierarchy returned by repositories (wrapped in `Either`).
// Keeps the `domain`/`presentation` layers decoupled from exception types.

import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures. Equatable so Cubit states
/// carrying a [Failure] compare correctly in tests and `BlocBuilder`.
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// The backend returned an error response.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Reading/writing local storage failed.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// No network connectivity was available.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Authentication-specific failure (e.g. invalid credentials).
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Fallback for anything not explicitly categorized above.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
