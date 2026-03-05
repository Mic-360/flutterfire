import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire/features/auth/data/auth_providers.dart';
import 'package:flutterfire/features/home/data/notes_repository.dart';
import 'package:flutterfire/shared/widgets/loading_view.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logAppOpen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterFire Starter'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (!mounted) return;
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'New note',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    await ref.read(notesRepositoryProvider).addNote(text);
                    _controller.clear();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: notes.when(
                data: (items) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(items[index].text),
                    subtitle: Text(items[index].createdAt.toIso8601String()),
                  ),
                ),
                loading: LoadingView.new,
                error: (error, stack) => Text('Failed to load notes: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
