// States emitted by AuthCubit, modeled as a sealed-style class hierarchy so
// `BlocBuilder`/`BlocListener` can switch on them exhaustively.

import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// States of the authentication flow.
/// Sealed-style pattern using final classes that extend AuthState.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State while waiting for the server response.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when login succeeded.
final class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when login failed, carrying the corresponding error message.
final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
