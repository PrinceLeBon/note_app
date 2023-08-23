import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/hashtag.dart';
import '../providers/firestore.dart';

class HashTagRepository {
  final FirestoreAPI firestoreAPI = const FirestoreAPI();

  Future<List<HashTag>> getAllHashTags() async {
    List<HashTag> hashTagList = [];
    try {
      QuerySnapshot docs = await firestoreAPI.get("hashTags");

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      hashTagList = result.map<HashTag>((e) => HashTag.fromJson(e)).toList();
    } catch (e) {
      Logger().e("HashTagRepository || Error while getAllHashTags: $e");
      rethrow;
    }
    return hashTagList;
  }

  Future addDocs(HashTag hashTag) async {
    try {
      await firestoreAPI.addDocs("hashTags", hashTag.toJson());
    } catch (e) {
      Logger().e("HashTagRepository || Error while addDocs: $e");
      rethrow;
    }
  }
}
