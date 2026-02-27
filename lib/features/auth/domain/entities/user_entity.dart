import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Pure domain entity representing an authenticated user.
/// Has ZERO dependency on Flutter, Firebase, or any data-layer packages.
/// This is the single source of truth for user data in the domain layer.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;

  /// One of: [AppConstants.roleEmployee], [AppConstants.roleAdmin],
  /// [AppConstants.rolePicProject], [AppConstants.roleFinance].
  final String role;

  final String? photoUrl;

  /// Accounts deactivated by Admin cannot authenticate at the app level.
  final bool isActive;

  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.isActive = true,
    this.createdAt,
  });

  /// Returns true when this user holds any of the provided [roles].
  bool hasRole(String role) => this.role == role;

  bool get isEmployee => role == AppConstants.roleEmployee;
  bool get isAdmin => role == AppConstants.roleAdmin;
  bool get isPicProject => role == AppConstants.rolePicProject;
  bool get isFinance => role == AppConstants.roleFinance;

  /// True when user can approve submissions (PIC Project or Finance).
  bool get isApprover => isPicProject || isFinance;

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserEntity(
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
  List<Object?> get props => [uid, email, displayName, role, photoUrl, isActive];

  @override
  String toString() =>
      'UserEntity(uid: $uid, email: $email, role: $role, isActive: $isActive)';
}
