import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static bool get useEmulators =>
      dotenv.maybeGet('FIREBASE_EMULATORS_ENABLED') == 'true';

  static String get environment => dotenv.maybeGet('APP_ENV') ?? 'development';
}
