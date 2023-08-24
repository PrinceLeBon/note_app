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
    } catch (e) {
      Logger().e("NoteRepository || Error while addDocs: $e");
      rethrow;
    }
  }
}
