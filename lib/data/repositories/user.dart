import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/providers/firestore.dart';
import 'package:note_app/data/providers/user.dart';
import '../models/user.dart';

class UserRepository {
  final UserAPI userAPI = const UserAPI();
  final FirestoreAPI firestoreAPI = const FirestoreAPI();

  Future<UserModel> login(String email, String password) async {
    late UserModel user;

    try {
      await userAPI.login(email, password);
      user = await getUserInfos();
    } catch (e) {
      Logger().e("UserRepository || Error while login: $e");
      rethrow;
    }
    return user;
  }

  Future<UserModel> getUserInfos() async {
    late UserModel user;
    try {
      QuerySnapshot docs = await firestoreAPI.get("users");

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      user = result.map<UserModel>((e) => UserModel.fromJson(e)).toList().first;
    } catch (e) {
      Logger().e("UserRepository || Error while getUserInfos: $e");
      rethrow;
    }
    return user;
  }

  Future<void> signup(String nom, String prenom, String mail, File photo,
      String password) async {
    try {
      UserCredential userInfos = await userAPI.signup(mail, password);
      Reference ref = await firestoreAPI.addFile(
          "userprofiles", "${userInfos.user?.uid}.jpg", photo);

      String photoPath = await ref.getDownloadURL();

      UserModel user = UserModel(
        id: (userInfos.user?.uid)!,
        nom: nom,
        prenom: prenom,
        email: mail,
        photo: photoPath,
      );
      await userAPI.addDocs(user);

      final Box userBox = Hive.box("User");
      userBox.put("user", user);
    } catch (e) {
      Logger().e("UserRepository || Error while signup: $e");
      rethrow;
    }
  }
}
