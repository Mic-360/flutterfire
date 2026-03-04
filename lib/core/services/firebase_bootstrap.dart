import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfire/core/config/env.dart';

Future<void> bootstrapFirebaseServices() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
    appleProvider: kReleaseMode ? AppleProvider.appAttest : AppleProvider.debug,
  );

  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  await FirebaseRemoteConfig.instance.setDefaults(
    const {'welcome_message': 'Welcome to FlutterFire Starter'},
  );

  if (!kIsWeb) {
    await FirebaseMessaging.instance.requestPermission();
  }

  if (EnvConfig.useEmulators) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
}
