import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire/app/app.dart';
import 'package:flutterfire/core/services/firebase_bootstrap.dart';
import 'package:flutterfire/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Proceed without .env; rely on defaults or other configuration.
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrapFirebaseServices();

  runApp(const ProviderScope(child: StarterApp()));
}
