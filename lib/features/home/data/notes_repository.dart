import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire/core/constants/firestore_paths.dart';
import 'package:flutterfire/features/home/data/note.dart';

class NotesRepository {
  NotesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore.collection(FirestorePaths.notes);

  Stream<List<Note>> watchNotes() {
    return _notesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Note.fromDoc).toList());
  }

  Future<void> addNote(String text) {
    final note = Note(id: '', text: text, createdAt: DateTime.now());
    return _notesRef.add(note.toMap());
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(ref.watch(firestoreProvider));
});

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  return ref.watch(notesRepositoryProvider).watchNotes();
});
