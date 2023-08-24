import 'package:flutter/material.dart';
import 'package:note_app/presentation/screens/signin.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final nameController1 = TextEditingController();
  final passwordController2 = TextEditingController();

  @override
  void dispose() {
    nameController1.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: nameController1,
                    size: 14,
                    hintText: "Adresse mail",
                    letterSpacing: false,
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  CustomTextField(
                    controller: nameController1,
                    size: 14,
                    hintText: "Mot de passe",
                    letterSpacing: false,
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entre un mot de passe';
                      } else if (value.length < 6) {
                        return 'Votre mot de passe doit dépasser 5 caractères';
                      }
                      return null;
                    },
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  const TextButton(
                    onPressed: null,
                    child: GoogleText(
                      text: "Se connecter",
                      color: Colors.white,
                    ),
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SignIn();
                    })),
                    child: const GoogleText(
                      text: "S'inscrire",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
