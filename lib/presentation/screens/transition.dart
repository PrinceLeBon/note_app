import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/progress_indicator.dart';
import 'homepage.dart';
import 'login.dart';

class TransitionPage extends StatelessWidget {
  const TransitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Something has wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            return const MyHomePage();
          } else {
            return const Login();
          }
        });
  }
}
