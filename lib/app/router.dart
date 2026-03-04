import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire/features/auth/presentation/auth_gate.dart';
import 'package:flutterfire/features/auth/presentation/login_page.dart';
import 'package:flutterfire/features/auth/presentation/signup_page.dart';
import 'package:flutterfire/features/home/presentation/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
  redirect: (context, state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    final inAuth = state.fullPath == '/login' || state.fullPath == '/signup';

    if (!loggedIn && !inAuth) return '/login';
    if (loggedIn && inAuth) return '/home';
    return null;
  },
);
