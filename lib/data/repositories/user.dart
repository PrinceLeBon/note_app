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

  Future logout() async {
    try {
      await userAPI.logout();
      final Box userBox = Hive.box("User");
      userBox.delete("user");
    } catch (e) {
      Logger().e("UserRepository || Error while logout: $e");
      rethrow;
    }
  }

  Future<UserModel> getUserInfos() async {
    late UserModel user;
    try {
      final Box userBox = Hive.box("User");
      UserModel userFromBox = userBox.get(
        "user",
        defaultValue: UserModel(
            id: "id",
            nom: "nom",
            prenom: "prenom",
            email: "email",
            photo: "photo"),
      );

      QuerySnapshot docs = await firestoreAPI.get(
          "users",
          (userFromBox.id == "id")
              ? (FirebaseAuth.instance.currentUser?.uid)!
              : userFromBox.id);

      List<Map<String, dynamic>> result =
          docs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      user = result.map<UserModel>((e) => UserModel.fromJson(e)).toList().first;
      userBox.put("user", user);
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

      String photoPath = "";

      if (photo.path.isNotEmpty) {
        Reference ref = await firestoreAPI.addFile(
            "userprofiles", "${userInfos.user?.uid}.jpg", photo);

        photoPath = await ref.getDownloadURL();
      }

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
      //Logger().i(user);
    } catch (e) {
      Logger().e("UserRepository || Error while signup: $e");
      rethrow;
    }
  }

  Future<UserModel> updateUser(UserModel updatedUser, File? newPhoto) async {
    try {
      // Check if user is authenticated
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }
      
      // Ensure the user is updating their own profile
      if (currentUser.uid != updatedUser.id) {
        throw Exception("User can only update their own profile");
      }
      
      String photoUrl = updatedUser.photo;
      
      // If new photo provided, upload it
      if (newPhoto != null && newPhoto.path.isNotEmpty) {
        try {
          // Use a timestamp to avoid caching issues
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          Reference ref = await firestoreAPI.addFile(
              "userprofiles", "${updatedUser.id}_$timestamp.jpg", newPhoto);
          photoUrl = await ref.getDownloadURL();
        } catch (storageError) {
          Logger().e("Storage error: $storageError");
          // If storage fails, continue with profile update without photo
          throw Exception("Erreur lors du téléchargement de la photo. Vérifiez vos permissions Firebase Storage.");
        }
      }
      
      // Create updated user with new photo URL if changed
      UserModel userToUpdate = updatedUser.copyWith(photo: photoUrl);
      
      // Update in Firestore
      await firestoreAPI.updateDocs(
          "users", updatedUser.id, userToUpdate.toJson(), updatedUser.id);
      
      // Update in local Hive storage
      final Box userBox = Hive.box("User");
      userBox.put("user", userToUpdate);
      
      return userToUpdate;
    } catch (e) {
      Logger().e("UserRepository || Error while updating user: $e");
      rethrow;
    }
  }

  UserModel? getCurrentUser() {
    try {
      final Box userBox = Hive.box("User");
      UserModel? user = userBox.get("user");
      return user;
    } catch (e) {
      Logger().e("UserRepository || Error while getting current user: $e");
      return null;
    }
  }
}
