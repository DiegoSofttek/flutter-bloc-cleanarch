// Data-layer model that adds JSON (de)serialization on top of the entity.
// Only `data` should know about JSON shapes; `domain` only sees UserEntity.

import '../../domain/entities/user_entity.dart';

/// Data model that extends [UserEntity].
/// Adds JSON serialization capabilities specific to the data layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
