import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../constants/firebase_constants.dart';
import '../utils/logger.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.i(
    '[FCM:background] messageId=${message.messageId} data=${message.data}',
  );
}

class NotificationService {
  NotificationService({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
  })  : _messaging = messaging,
        _firestore = firestore;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  bool _streamsBound = false;
  String? _activeUid;

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> configureForSignedInUser({
    required String uid,
    required String role,
    required GoRouter router,
  }) async {
    _activeUid = uid;

    await _requestPermissions();
    await _syncToken(uid: uid, role: role);
    await _syncRoleTopics(role: role);
    await _bindMessageStreams(uid: uid, router: router);
  }

  Future<void> clearForSignedOutUser({
    required String uid,
    required String role,
  }) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(uid)
            .collection('deviceTokens')
            .doc(token)
            .delete();
      }
    } catch (e, st) {
      AppLogger.w('[FCM] Failed removing token on sign-out', e, st);
    }

    await _unsubscribeAllRoleTopics();
    _activeUid = null;
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
      carPlay: false,
      announcement: false,
    );

    AppLogger.i('[FCM] Permission status: ${settings.authorizationStatus}');
  }

  Future<void> _syncToken({required String uid, required String role}) async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      AppLogger.w('[FCM] Token unavailable for uid=$uid');
      return;
    }

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .collection('deviceTokens')
        .doc(token)
        .set({
      'token': token,
      'uid': uid,
      'role': role,
      'platform': Platform.isIOS ? 'ios' : 'android',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    AppLogger.i('[FCM] Token synced for uid=$uid');
  }

  Future<void> _syncRoleTopics({required String role}) async {
    await _unsubscribeAllRoleTopics();

    if (role == AppConstants.roleFinance) {
      await _messaging.subscribeToTopic(FirebaseConstants.topicFinance);
    } else if (role == AppConstants.rolePicProject) {
      await _messaging.subscribeToTopic(FirebaseConstants.topicPicProject);
    } else if (role == AppConstants.roleAdmin) {
      await _messaging.subscribeToTopic(FirebaseConstants.topicAdmin);
    }

    AppLogger.i('[FCM] Topic subscription synced for role=$role');
  }

  Future<void> _unsubscribeAllRoleTopics() async {
    await _messaging.unsubscribeFromTopic(FirebaseConstants.topicFinance);
    await _messaging.unsubscribeFromTopic(FirebaseConstants.topicPicProject);
    await _messaging.unsubscribeFromTopic(FirebaseConstants.topicAdmin);
  }

  Future<void> _bindMessageStreams({
    required String uid,
    required GoRouter router,
  }) async {
    if (!_streamsBound) {
      FirebaseMessaging.onMessage.listen((message) {
        final title = message.notification?.title ?? 'Notification';
        final body = message.notification?.body ?? '';
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              body.isEmpty ? title : '$title\n$body',
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => _navigateFromData(router, message.data),
            ),
          ),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _navigateFromData(router, message.data);
      });

      _streamsBound = true;
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      if (_activeUid == null || _activeUid != uid) return;
      final docRef = _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection('deviceTokens')
          .doc(newToken);
      await docRef.set(
        {
          'token': newToken,
          'uid': uid,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      AppLogger.i('[FCM] Token refreshed for uid=$uid');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateFromData(router, initialMessage.data);
    }
  }

  void _navigateFromData(GoRouter router, Map<String, dynamic> data) {
    final module = data['module'] as String?;
    final documentId = data['documentId'] as String?;
    if (module == null || documentId == null || documentId.isEmpty) return;

    final route = switch (module) {
      'cash_advance' => '/cash-advance/$documentId',
      'allowance' => '/allowance/$documentId',
      'reimbursement' => '/reimbursement/$documentId',
      _ => null,
    };

    if (route != null) {
      router.go(route);
    }
  }
}
