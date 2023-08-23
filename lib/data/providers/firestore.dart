import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

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
}
