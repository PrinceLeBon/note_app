import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new,
        ),
        actions: const [
          Icon(Icons.menu),
          Gap(horizontalAlign: true, gap: 10),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: titleController,
                size: 40,
                hintText: "Title",
                letterSpacing: true,
              ),
              CustomTextField(
                controller: noteController,
                size: 20,
                hintText: "Ajouter une note",
                letterSpacing: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
