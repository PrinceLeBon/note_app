import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/models/user.dart';

class UserAPI {
  const UserAPI();

  Future<UserCredential> login(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future logout() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signup(String mail, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: mail, password: password);
  }

  Future addDocs(UserModel user) async {
    final doc = FirebaseFirestore.instance.collection("users").doc(user.id);

    await doc.set(user.toJson()).onError(
        (error, stackTrace) => Logger().e("Error writing document: $error"));
  }
}
