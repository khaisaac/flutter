import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'core/utils/logger.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // ── Flutter engine binding ────────────────────────────────────────────────
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI / orientation ───────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ── Firebase initialisation ───────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  AppLogger.i('Firebase initialised — project: reimbursement-hexa');

  // ── Run app inside ProviderScope ──────────────────────────────────────────
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}


