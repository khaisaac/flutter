import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/storage_service.dart';

part 'app_providers.g.dart';

// ── Firebase Service Providers ─────────────────────────────────────────────
// These expose Firebase SDK instances so feature-level providers can depend
// on them without hardcoding singleton access throughout the app.

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) =>
    FirebaseStorage.instance;

// FirebaseMessaging provider added in the Push Notifications step.
// firebase_messaging requires Dart >=3.4.0 / Flutter >=3.22.

// ── Secure Storage ─────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) =>
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );

// ── Storage Service ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) =>
    StorageService(ref.watch(firebaseStorageProvider));
