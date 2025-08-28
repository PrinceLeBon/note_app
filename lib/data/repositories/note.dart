import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/data/providers/firestore.dart';

import '../models/user.dart';

class NoteRepository {
  final FirestoreAPI firestoreAPI = const FirestoreAPI();

  Future<List<Note>> getAllNotes() async {
    List<Note> noteList = [];
    try {
      final Box userBox = Hive.box("User");
      UserModel user = userBox.get("user",
          defaultValue: UserModel(
              id: "id",
              nom: "nom",
              prenom: "prenom",
              email: "email",
              photo: "photo"));

      QuerySnapshot docs = await firestoreAPI.get(
          "notes",
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      noteList = result.map<Note>((e) => Note.fromJson(e)).toList();

      noteList.sort((a, b) => b.creationDate.compareTo(a.creationDate));

      final Box notesBox = Hive.box("Notes");
      notesBox.put("notesList", noteList);
    } catch (e) {
      Logger().e("NoteRepository || Error while getAllNotes: $e");
      rethrow;
    }
    return noteList;
  }

  Future addDocs(Note note) async {
    try {
      final Box userBox = Hive.box("User");
      UserModel user = userBox.get("user",
          defaultValue: UserModel(
              id: "id",
              nom: "nom",
              prenom: "prenom",
              email: "email",
              photo: "photo"));

      await firestoreAPI.addDocs(
          "notes",
          note.toJson(),
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);

      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      notesList.add(note);
      notesBox.put("notesList", notesList);
    } catch (e) {
      Logger().e("NoteRepository || Error while addDocs: $e");
      rethrow;
    }
  }

  Future deleteDocs(String docId) async {
    try {
      await firestoreAPI.deleteDocs("notes", docId);

      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      notesList.removeWhere((note) => note.id == docId);
      notesBox.put("notesList", notesList);
    } catch (e) {
      Logger().e("NoteRepository || Error while addDocs: $e");
      rethrow;
    }
  }

  Future updateNote(Note updatedNote) async {
    try {
      final Box userBox = Hive.box("User");
      UserModel user = userBox.get("user",
          defaultValue: UserModel(
              id: "id",
              nom: "nom",
              prenom: "prenom",
              email: "email",
              photo: "photo"));

      await firestoreAPI.updateDocs(
          "notes",
          updatedNote.id,
          updatedNote.toJson(),
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);

      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();

      int index = notesList.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notesList[index] = updatedNote;
        notesBox.put("notesList", notesList);
      }
    } catch (e) {
      Logger().e("NoteRepository || Error while updateNote: $e");
      rethrow;
    }
  }
}
