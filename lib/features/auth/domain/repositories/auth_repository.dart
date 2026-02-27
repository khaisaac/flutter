import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';

/// Abstract contract for authentication operations.
/// Both the data layer implementation and test mocks implement this interface.
/// The domain layer depends ONLY on this contract — never on Firebase directly.
abstract class AuthRepository {
  /// Authenticates with email and password.
  /// Returns [UserEntity] on success or a typed [Failure] on the left.
  FutureEither<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Clears the current Firebase Auth session.
  FutureEither<void> signOut();

  /// Returns the currently authenticated user, or null if not signed in.
  FutureEither<UserEntity?> getCurrentUser();

  /// Emits the current user whenever the Firebase Auth state changes.
  /// Emits null when the user signs out or the token expires.
  Stream<UserEntity?> watchAuthState();

  /// Refreshes the ID token to pick up updated custom claims (e.g. role change).
  FutureEither<UserEntity> refreshUserToken();
}
