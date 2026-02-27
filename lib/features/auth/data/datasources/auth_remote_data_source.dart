import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/user_model.dart';

/// Contract for the remote authentication data source.
/// Isolates raw Firebase SDK calls from repository logic.
abstract class AuthRemoteDataSource {
  /// Signs in and returns a hydrated [UserModel] with claims-based role.
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the current Firebase Auth user.
  Future<void> signOut();

  /// Returns the current [UserModel] if a Firebase user is cached, else null.
  Future<UserModel?> getCurrentUser();

  /// Stream of [UserModel?] from the Firebase Auth state change events.
  Stream<UserModel?> watchAuthState();

  /// Forces an ID token refresh and returns an updated [UserModel].
  /// Needed after an admin updates the user's custom claims (role change).
  Future<UserModel> refreshCurrentUser();
}

// ── Implementation ─────────────────────────────────────────────────────────

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;

  const AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final idTokenResult = await user.getIdTokenResult();

    return UserModel.fromFirebaseUser(
      user,
      claims: idTokenResult.claims,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    // Refresh token to ensure claims are up to date.
    final idTokenResult = await user.getIdTokenResult();
    return UserModel.fromFirebaseUser(user, claims: idTokenResult.claims);
  }

  @override
  Stream<UserModel?> watchAuthState() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final idTokenResult = await user.getIdTokenResult();
      return UserModel.fromFirebaseUser(user, claims: idTokenResult.claims);
    });
  }

  @override
  Future<UserModel> refreshCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    // Force=true invalidates the cached token.
    final idTokenResult = await user.getIdTokenResult(true);
    return UserModel.fromFirebaseUser(user, claims: idTokenResult.claims);
  }
}
