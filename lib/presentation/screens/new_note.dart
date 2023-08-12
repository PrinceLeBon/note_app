import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
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
                     // pickColor(context);
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
/*
  Future pickColor(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              /*child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),*/
              // Use Material color picker:
              //
              /*child: MaterialPicker(
                 pickerColor: pickerColor,
                 onColorChanged: changeColor,
                 //showLabel: true, // only on portrait mode
               ),*/
              //
              // Use Block color picker:
              //
              child: BlockPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
              ),
              //
              /*child: MultipleChoiceBlockPicker(
                 pickerColors: currentColors,
                 onColorsChanged: changeColors,
               ),*/
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }*/
}
