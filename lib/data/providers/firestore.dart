import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreAPI {
  const FirestoreAPI();

  Future<QuerySnapshot> get(String collectionName) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionName);

    final Box userBox = Hive.box("User");
    String userId = userBox.get("id", defaultValue: "");

    var docs =
        await collectionReference.where("userId", isEqualTo: userId).get();

    return docs;
  }

  Future addDocs(String collectionName, Map<String, dynamic> data) async {
    final doc = FirebaseFirestore.instance.collection(collectionName).doc();

    data["id"] = doc.id;

    if (collectionName != "users") {
      final Box userBox = Hive.box("User");
      String userId = userBox.get("id", defaultValue: "");
      data["userId"] = userId;
    }

    await doc.set(data).onError(
        (error, stackTrace) => Logger().e("Error writing document: $error"));
  }

  Future<Reference> addFile(String folder, String name, File file) async {
    final ref = FirebaseStorage.instance.ref().child(folder).child(name);
    await ref.putFile(file);
    return ref;
  }
}
