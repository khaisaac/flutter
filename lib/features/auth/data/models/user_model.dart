import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Data-layer representation of a user.
/// Capable of serialising to/from JSON (Firestore) and
/// mapping from a [firebase_auth.User] with claim-based role.
///
/// The [fromFirebaseUser] factory is used immediately after sign-in.
/// The [fromJson] / [toJson] factories are used when persisting to Firestore
/// (implemented in Step 3 — User Profile).
@JsonSerializable(explicitToJson: true)
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String? photoUrl;
  final bool isActive;

  @JsonKey(
    fromJson: _dateTimeFromTimestamp,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.isActive = true,
    this.createdAt,
  });

  // ── Factory: Firebase Auth user + custom claims ───────────────────────────

  /// Constructs a [UserModel] from a Firebase [fb.User] and its ID token claims.
  /// The role is read from the custom claim key `'role'` set by a Cloud Function.
  /// Falls back to [AppConstants.roleEmployee] when the claim is absent.
  factory UserModel.fromFirebaseUser(
    fb.User user, {
    Map<String, dynamic>? claims,
  }) {
    final role = (claims?['role'] as String?) ?? AppConstants.roleEmployee;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'User',
      role: role,
      photoUrl: user.photoURL,
      isActive: true,
      createdAt: user.metadata.creationTime,
    );
  }

  // ── JSON serialization (generated) ────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // ── Domain mapping ────────────────────────────────────────────────────────

  UserEntity toEntity() => UserEntity(
        uid: uid,
        email: email,
        displayName: displayName,
        role: role,
        photoUrl: photoUrl,
        isActive: isActive,
        createdAt: createdAt,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        uid: entity.uid,
        email: entity.email,
        displayName: entity.displayName,
        role: entity.role,
        photoUrl: entity.photoUrl,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
      );

  // ── Helpers ───────────────────────────────────────────────────────────────

  static DateTime? _dateTimeFromTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static int? _dateTimeToTimestamp(DateTime? dt) =>
      dt?.millisecondsSinceEpoch;

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, email: $email, role: $role)';
}
