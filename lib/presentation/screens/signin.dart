import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../business_logic/cubit/users/user_cubit.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gap.dart';
import '../widgets/google_text.dart';
import '../widgets/progress_indicator.dart';
import 'login.dart';

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
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is Signin) {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Login()));
              CustomSnackBar(content: "Inscrit(e)", context: context)
                  .showSnackBar();
            } else if (state is SigningFailed) {
              CustomSnackBar(
                      content: "Une erreur est survenue, veuillez réésayer",
                      context: context,
                      isError: true)
                  .showSnackBar();
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: (state is Signing)
                    ? const CustomProgressIndicator()
                    : SingleChildScrollView(
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
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: Icon(Icons.camera_alt),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: FileImage(File(
                                                    (selectedContent?.path)!)),
                                                fit: BoxFit.cover)),
                                      ),
                                const Gap(horizontalAlign: false, gap: 20),
                                const GoogleText(
                                  text: "Photo de profil",
                                  color: Color(0xff848181),
                                ),
                                const Gap(horizontalAlign: false, gap: 10),
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
                                    } else if (passwordController1.text
                                            .trim() !=
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
                                    } else if (passwordController1.text
                                            .trim() !=
                                        passwordController2.text.trim()) {
                                      return "Les mots de passe doivent etre identitiques";
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(horizontalAlign: false, gap: 10),
                                TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<UserCubit>().signup(
                                          nameController.text.trim(),
                                          prenomController.text.trim(),
                                          mailController.text.trim(),
                                          File(selectedContent?.path ?? ""),
                                          passwordController2.text.trim());
                                    }
                                  },
                                  child: const GoogleText(
                                    text: "S'inscrire",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
              ),
            );
          },
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
