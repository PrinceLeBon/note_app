import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gap.dart';
import '../widgets/google_text.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  XFile? selectedContent;

  @override
  void dispose() {
    nameController.dispose();
    prenomController.dispose();
    mailController.dispose();
    passwordController2.dispose();
    passwordController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (selectedContent == null)
                        ? InkWell(
                            onTap: () => pickImage(),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(
                                        File((selectedContent?.path)!)),
                                    fit: BoxFit.cover)),
                          ),
                    CustomTextField(
                      controller: nameController,
                      size: 14,
                      hintText: "Nom",
                      letterSpacing: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    CustomTextField(
                      controller: prenomController,
                      size: 14,
                      hintText: "Prénom",
                      letterSpacing: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    CustomTextField(
                      controller: mailController,
                      size: 14,
                      hintText: "Adresse mail",
                      letterSpacing: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    CustomTextField(
                      controller: passwordController1,
                      size: 14,
                      hintText: "Mot de passe",
                      letterSpacing: false,
                      password: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entre un mot de passe';
                        } else if (value.length < 6) {
                          return 'Votre mot de passe doit dépasser 5 caractères';
                        } else if (passwordController1.text.trim() !=
                            passwordController2.text.trim()) {
                          return "Les mots de passe doivent etre identitiques";
                        }
                        return null;
                      },
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    CustomTextField(
                      controller: passwordController2,
                      size: 14,
                      hintText: "Confirmer le mot de passe",
                      letterSpacing: false,
                      password: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entre un mot de passe';
                        } else if (value.length < 6) {
                          return 'Votre mot de passe doit dépasser 5 caractères';
                        } else if (passwordController1.text.trim() !=
                            passwordController2.text.trim()) {
                          return "Les mots de passe doivent etre identitiques";
                        }
                        return null;
                      },
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
                )),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      XFile? imageSelected =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        selectedContent = imageSelected;
      });

    } on PlatformException catch (e) {
      Logger().i('Failure to select the image: $e');
    }
  }
}
