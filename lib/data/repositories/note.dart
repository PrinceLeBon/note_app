import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/data/providers/firestore.dart';

class NoteRepository {
  final FirestoreAPI firestoreAPI = const FirestoreAPI();

  Future<List<Note>> getAllNotes() async {
    List<Note> noteList = [];
    try {
      QuerySnapshot docs = await firestoreAPI.get("notes");

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      noteList = result.map<Note>((e) => Note.fromJson(e)).toList();
    } catch (e) {
      Logger().e("NoteRepository || Error while getAllNotes: $e");
      rethrow;
    }
    return noteList;
  }

  Future addDocs(Note note) async {
    try {
      await firestoreAPI.addDocs("notes", note.toJson());
    } catch (e) {
      Logger().e("NoteRepository || Error while addDocs: $e");
      rethrow;
    }
  }
}
