import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/business_logic/cubit/users/user_cubit.dart';
import 'package:note_app/presentation/screens/connexion/signin.dart';
import 'package:note_app/presentation/screens/splash_screen.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import '../../../business_logic/cubit/hashtags/hashtag_cubit.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/progress_indicator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is Logged) {
            context.read<HashtagCubit>().getHashTags();
            context.read<NoteCubit>().getNotes();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const SplashScreen();
            }), (route) => false);
            CustomSnackBar(content: "Connecté(e)", context: context)
                .showSnackBar();
          } else if (state is LoggingFailed) {
            CustomSnackBar(
                    content: "Une erreur est survenue, veuillez réésayer",
                    context: context,
                    isError: true)
                .showSnackBar();
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: (state is Logging)
                  ? const CustomProgressIndicator()
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              controller: mailController,
                              size: 14,
                              hintText: "Adresse mail",
                              letterSpacing: false,
                            ),
                            const Gap(horizontalAlign: false, gap: 10),
                            CustomTextField(
                              controller: passwordController,
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
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<UserCubit>().login(
                                      mailController.text.trim(),
                                      passwordController.text.trim());
                                }
                              },
                              child: const GoogleText(
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
          ));
        },
      ),
    );
  }
}
