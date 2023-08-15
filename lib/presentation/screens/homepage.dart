import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/presentation/screens/firstpage.dart';
import 'package:note_app/presentation/screens/new_note.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import '../../business_logic/cubit/notes/note_cubit.dart';
import '../../utils/constants.dart';
import '../widgets/gap.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = -1;
  final TextEditingController researchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: whiteColor,
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
            : const GoogleText(text: "Hi, Prince Le Bon"),
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
      body: const FirstPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: whiteColor,
        onPressed: () {
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
  }
}
