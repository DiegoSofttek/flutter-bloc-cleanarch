// Immutable business entity for an authenticated user. Lives in `domain`
// only — no Flutter or `data` layer dependencies.

import 'package:equatable/equatable.dart';

/// Immutable business entity representing an authenticated user.
/// Belongs exclusively to the domain layer: no Flutter or data dependencies.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object> get props => [id, name, email, role];
}
