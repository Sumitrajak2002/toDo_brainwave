import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Create: add a new note
  Future<void> addNote(String note, bool isDone) {
    return notes.add({
      'note': note,
      'isDone': isDone,
    });
  }

  // Read: get notes from database
  Stream<QuerySnapshot> getNotesStream() {
    return notes.snapshots();
  }

  // Update: update notes given a doc id
  Future<void> updateNote(String docId, bool isDone) {
    return notes.doc(docId).update({
      'isDone': isDone,
    });
  }

  // Update : note text if updated

  Future<void> updateNoteText(String docId,  String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
    });
  }

  // Delete: delete notes given a doc id
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
    }
