import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../di/app_providers.dart';
import '../router/app_router.dart';
import 'notification_service.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService(
    messaging: ref.watch(firebaseMessagingProvider),
    firestore: ref.watch(firestoreProvider),
  );
}

@Riverpod(keepAlive: true)
class NotificationBootstrap extends _$NotificationBootstrap {
  String? _lastUid;
  String? _lastRole;

  @override
  Future<void> build() async {
    ref.listen(authStateStreamProvider, (_, next) {
      _handleAuthState(next.valueOrNull);
    });

    final current = ref.read(authStateStreamProvider).valueOrNull;
    await _handleAuthState(current);
  }

  Future<void> _handleAuthState(UserEntity? user) async {
    final service = ref.read(notificationServiceProvider);

    if (user == null) {
      if (_lastUid != null && _lastRole != null) {
        await service.clearForSignedOutUser(uid: _lastUid!, role: _lastRole!);
      }
      _lastUid = null;
      _lastRole = null;
      return;
    }

    _lastUid = user.uid;
    _lastRole = user.role;

    await service.configureForSignedInUser(
      uid: _lastUid!,
      role: _lastRole!,
      router: ref.read(appRouterProvider),
    );
  }
}
