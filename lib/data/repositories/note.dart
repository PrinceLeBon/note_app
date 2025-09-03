import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/data/providers/firestore.dart';
import 'package:note_app/services/connectivity_service.dart';
import 'package:note_app/services/sync_service.dart';

import '../models/user.dart';

class NoteRepository {
  final FirestoreAPI firestoreAPI;
  final SyncService? syncService;
  final ConnectivityService? connectivityService;
  final Logger _logger = Logger();
  
  NoteRepository({
    this.firestoreAPI = const FirestoreAPI(),
    this.syncService,
    this.connectivityService,
  });

  Future<List<Note>> getAllNotes() async {
    // OFFLINE-FIRST: Always load from local storage first
    final Box notesBox = Hive.box("Notes");
    List<Note> notesList = List.castFrom(
        notesBox.get("notesList", defaultValue: [])).cast<Note>();
    
    // Sort by creation date
    notesList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    
    // Then try to sync with online if connected
    if (connectivityService != null) {
      final isOnline = await connectivityService!.checkConnection();
      if (isOnline) {
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
          List<Note> onlineNotes = result.map<Note>((e) => Note.fromJson(e)).toList();
          
          // Update local storage with online data
          onlineNotes.sort((a, b) => b.creationDate.compareTo(a.creationDate));
          notesBox.put("notesList", onlineNotes);
          
          return onlineNotes;
        } catch (e) {
          _logger.e("Error syncing notes from online: $e");
          // Return local data if online sync fails
        }
      }
    }
    
    return notesList;
  }

  Future addDocs(Note note) async {
    try {
      // OFFLINE-FIRST: Save locally first
      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      notesList.add(note);
      await notesBox.put("notesList", notesList);
      _logger.i("Note saved locally: ${note.id}");
      
      // Get user info
      final Box userBox = Hive.box("User");
      UserModel user = userBox.get("user",
          defaultValue: UserModel(
              id: "id",
              nom: "nom",
              prenom: "prenom",
              email: "email",
              photo: "photo"));
      
      final userId = (user.id == "id")
          ? (FirebaseAuth.instance.currentUser?.uid)!
          : user.id;
      
      // Try to sync online
      if (connectivityService != null && syncService != null) {
        final isOnline = await connectivityService!.checkConnection();
        if (isOnline) {
          try {
            await firestoreAPI.addDocs(
                "notes",
                note.toJson(),
                userId);
            _logger.i("Note synced online: ${note.id}");
          } catch (e) {
            _logger.e("Failed to sync note online, adding to queue: $e");
            // Add to sync queue
            await syncService!.addToSyncQueue(
              type: 'create',
              collection: 'notes',
              data: note.toJson(),
              documentId: note.id,
            );
          }
        } else {
          _logger.i("Offline: Note added to sync queue");
          // Add to sync queue for later
          await syncService!.addToSyncQueue(
            type: 'create',
            collection: 'notes',
            data: note.toJson(),
            documentId: note.id,
          );
        }
      }
    } catch (e) {
      _logger.e("NoteRepository || Error while addDocs: $e");
      rethrow;
    }
  }

  Future deleteDocs(String docId) async {
    try {
      // OFFLINE-FIRST: Delete locally first
      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      notesList.removeWhere((note) => note.id == docId);
      await notesBox.put("notesList", notesList);
      _logger.i("Note deleted locally: $docId");
      
      // Try to sync online
      if (connectivityService != null && syncService != null) {
        final isOnline = await connectivityService!.checkConnection();
        if (isOnline) {
          try {
            await firestoreAPI.deleteDocs("notes", docId);
            _logger.i("Note deleted online: $docId");
          } catch (e) {
            _logger.e("Failed to delete note online, adding to queue: $e");
            // Add to sync queue
            await syncService!.addToSyncQueue(
              type: 'delete',
              collection: 'notes',
              data: {'id': docId},
              documentId: docId,
            );
          }
        } else {
          _logger.i("Offline: Delete operation added to sync queue");
          // Add to sync queue for later
          await syncService!.addToSyncQueue(
            type: 'delete',
            collection: 'notes',
            data: {'id': docId},
            documentId: docId,
          );
        }
      }
    } catch (e) {
      _logger.e("NoteRepository || Error while deleteDocs: $e");
      rethrow;
    }
  }

  Future updateNote(Note updatedNote) async {
    try {
      // OFFLINE-FIRST: Update locally first
      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      
      int index = notesList.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notesList[index] = updatedNote;
        await notesBox.put("notesList", notesList);
        _logger.i("Note updated locally: ${updatedNote.id}");
      }
      
      // Get user info
      final Box userBox = Hive.box("User");
      UserModel user = userBox.get("user",
          defaultValue: UserModel(
              id: "id",
              nom: "nom",
              prenom: "prenom",
              email: "email",
              photo: "photo"));
      
      final userId = (user.id == "id")
          ? (FirebaseAuth.instance.currentUser?.uid)!
          : user.id;
      
      // Try to sync online
      if (connectivityService != null && syncService != null) {
        final isOnline = await connectivityService!.checkConnection();
        if (isOnline) {
          try {
            await firestoreAPI.updateDocs(
                "notes",
                updatedNote.id,
                updatedNote.toJson(),
                userId);
            _logger.i("Note updated online: ${updatedNote.id}");
          } catch (e) {
            _logger.e("Failed to update note online, adding to queue: $e");
            // Add to sync queue
            await syncService!.addToSyncQueue(
              type: 'update',
              collection: 'notes',
              data: updatedNote.toJson(),
              documentId: updatedNote.id,
            );
          }
        } else {
          _logger.i("Offline: Update operation added to sync queue");
          // Add to sync queue for later
          await syncService!.addToSyncQueue(
            type: 'update',
            collection: 'notes',
            data: updatedNote.toJson(),
            documentId: updatedNote.id,
          );
        }
      }
    } catch (e) {
      _logger.e("NoteRepository || Error while updateNote: $e");
      rethrow;
    }
  }
}
