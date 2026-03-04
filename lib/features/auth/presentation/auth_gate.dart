import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire/features/auth/data/auth_providers.dart';
import 'package:flutterfire/features/home/presentation/home_page.dart';
import 'package:flutterfire/shared/widgets/loading_view.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) => user == null
          ? const Scaffold(body: Center(child: Text('Please login.')))
          : const HomePage(),
      loading: LoadingView.new,
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Auth error: $error')),
      ),
    );
  }
}
