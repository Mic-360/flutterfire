# FlutterFire Starter (Modernized)

A lightweight Flutter + Firebase boilerplate designed for quickly bootstrapping production-ready apps.

## Overview

This starter includes:
- Modern Flutter app structure (`app`, `core`, `features`, `shared`)
- Firebase initialization via **FlutterFire CLI pattern**
- Riverpod state management
- GoRouter navigation
- Auth starter (email/password sign in, sign up, sign out, auth listener)
- Firestore starter (typed model + repository + read/write stream)
- Environment configuration with `flutter_dotenv`
- Firebase service bootstrap hooks for App Check, Crashlytics, Messaging, and Remote Config

## Requirements

- Flutter stable (`>=3.22.0`)
- Dart SDK (`>=3.3.0`)
- Firebase project
- FlutterFire CLI

## Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Create local env file:
   ```bash
   cp .env.example .env
   ```
3. Configure Firebase for your own app:
   ```bash
   flutterfire configure
   ```
   This updates/regenerates `lib/firebase_options.dart` and links Android/iOS/Web apps.
4. Run the app:
   ```bash
   flutter run
   ```

## Firebase Configuration Notes

The app initializes Firebase with:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

`lib/firebase_options.dart` is included as a template and should be replaced by your generated file from `flutterfire configure`.

## Folder Structure

```txt
lib/
  app/
    app.dart
    router.dart
  core/
    config/
    constants/
    services/
    utils/
  features/
    auth/
      data/
      presentation/
    home/
      data/
      presentation/
  shared/
    widgets/
  firebase_options.dart
  main.dart
```

## Starter Template Workflow (new project)

1. Clone this repo.
2. Rename package/app identifiers:
   - Flutter project name in `pubspec.yaml`
   - Android applicationId in `android/app/build.gradle`
   - iOS bundle id in Xcode project settings
3. Run:
   ```bash
   flutter clean
   flutter pub get
   flutterfire configure
   ```
4. Update `.env` values and start building features.

## Environment Variables

See `.env.example`:

- `FIREBASE_EMULATORS_ENABLED` - set `true` to route Auth to local emulator (localhost:9099)
- `APP_ENV` - environment label (development/staging/production)

## Platform Support

This template targets Android, iOS, and Web with FlutterFire-compatible initialization.

## Quality

- Lints: `flutter_lints`
- Recommended check:
  ```bash
  flutter analyze
  ```

