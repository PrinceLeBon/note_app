import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/show_hashtags.dart';
import 'package:note_app/utils/constants.dart';
import '../widgets/custom_dropdown.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  Color currentColor = Colors.blue;
  Color pickerColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: const [
          Icon(Icons.save),
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
              Row(
                children: [
                  const Expanded(
                    child: CustomDropDown(list: [
                      "hashtag",
                    ]),
                  ),
                  const Gap(horizontalAlign: true, gap: 10),
                  InkWell(
                    onTap: () {
                      pickColor(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: blackColor,
                        size: 16.0,
                      ),
                    ),
                  )
                ],
              ),
              const ShowHashtags(hashtags: [
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
                "hashtag",
              ]),
              CustomTextField(
                controller: noteController,
                size: 15,
                hintText: "Ajouter une note",
                letterSpacing: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future pickColor(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: blackColor,
            title: const GoogleText(
              text: "Choisissez une couleur !",
              fontWeight: true,
              fontSize: 20,
            ),
            content: SingleChildScrollView(
              child: MaterialPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(blackColor)),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
                child: const GoogleText(text: "Valider"),
              ),
            ],
          );
        });
  }
}
