import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/business_logic/cubit/users/user_cubit.dart';
import 'package:note_app/data/models/user.dart';
import 'package:note_app/presentation/screens/firstpage.dart';
import 'package:note_app/presentation/screens/new_note.dart';
import 'package:note_app/presentation/widgets/custom_drawer.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/progress_indicator.dart';
import '../../business_logic/cubit/notes/note_cubit.dart';
import '../../utils/constants.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/gap.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  final UserModel user;

  const MyHomePage({super.key, required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = -1;
  final TextEditingController researchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is Logout) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
          CustomSnackBar(content: "Déconnecté(e)", context: context)
              .showSnackBar();
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(user: widget.user),
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: (widget.user.photo.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: widget.user.photo,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : null,
              ),
            ),
            title: (index < 0)
                ? CustomTextField(
                    controller: researchController,
                    size: 14,
                    hintText: "Entrer votre mot clé",
                    letterSpacing: false,
                    onChanged: (value) => context
                        .read<NoteCubit>()
                        .getFilteredNotesByResearch(
                            researchController.text.trim().toLowerCase()),
                  )
                : BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                    return GoogleText(text: "Hi ,${widget.user.prenom}");
                  }),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      index *= -1;
                    });
                    context.read<NoteCubit>().getFilteredNotesByResearch(
                        researchController.text.trim().toLowerCase());
                  },
                  icon: Icon(
                    Icons.search,
                    color: whiteColor,
                  )),
              const Gap(horizontalAlign: true, gap: 10),
            ],
          ),
          body: (state is LoggingOut)
              ? const Center(
                  child: CustomProgressIndicator(),
                )
              : const FirstPage(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: whiteColor,
            onPressed: () {
              context.read<HashtagCubit>().getHashTagsNew();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const NewNote();
              }));
            },
            child: Icon(
              Icons.add,
              color: blackColor,
            ),
          ),
        );
      },
    );
  }
}
