import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../models/hashtag.dart';
import '../models/user.dart';
import '../providers/firestore.dart';

class HashTagRepository {
  final FirestoreAPI firestoreAPI = const FirestoreAPI();

  Future<List<HashTag>> getAllHashTags() async {
    List<HashTag> hashTagList = [];
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
          "hashTags",
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      hashTagList = result.map<HashTag>((e) => HashTag.fromJson(e)).toList();

      hashTagList.sort((a, b) => b.creationDate.compareTo(a.creationDate));

      final Box noteBox = Hive.box("Notes");
      noteBox.put("hashTagsList", hashTagList);

    } catch (e) {
      Logger().e("HashTagRepository || Error while getAllHashTags: $e");
      rethrow;
    }
    return hashTagList;
  }

  Future addDocs(HashTag hashTag) async {
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
          "hashTags",
          hashTag.toJson(),
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);
    } catch (e) {
      Logger().e("HashTagRepository || Error while addDocs: $e");
      rethrow;
    }
  }

  Future updateHashTag(HashTag hashTag) async {
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
          "hashTags",
          hashTag.id,
          hashTag.toJson(),
          (user.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : user.id);

      // Update local cache
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      
      int index = hashTagsList.indexWhere((tag) => tag.id == hashTag.id);
      if (index != -1) {
        hashTagsList[index] = hashTag;
        noteBox.put("hashTagsList", hashTagsList);
      }
    } catch (e) {
      Logger().e("HashTagRepository || Error while updateHashTag: $e");
      rethrow;
    }
  }

  Future deleteHashTag(String hashTagId) async {
    try {
      await firestoreAPI.deleteDocs("hashTags", hashTagId);

      // Update local cache
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      
      hashTagsList.removeWhere((tag) => tag.id == hashTagId);
      noteBox.put("hashTagsList", hashTagsList);
    } catch (e) {
      Logger().e("HashTagRepository || Error while deleteHashTag: $e");
      rethrow;
    }
  }

  int checkHashTagUsage(String hashTagId) {
    try {
      final Box noteBox = Hive.box("Notes");
      List<dynamic> notesList =
          noteBox.get("notesList", defaultValue: []);
      
      int usageCount = 0;
      for (var note in notesList) {
        if (note.hashtagsId.contains(hashTagId)) {
          usageCount++;
        }
      }
      
      return usageCount;
    } catch (e) {
      Logger().e("HashTagRepository || Error while checkHashTagUsage: $e");
      return 0;
    }
  }
}
