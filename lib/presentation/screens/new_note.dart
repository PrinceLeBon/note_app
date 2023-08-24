import 'package:color_parser/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/show_hashtags.dart';
import 'package:note_app/utils/constants.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/progress_indicator.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();
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
        actions: [
          BlocBuilder<HashtagCubit, HashtagState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  if (state is HashTagsNewGotten) {
                    if (titleController.text.trim().isEmpty &&
                        noteController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: GoogleText(
                              text: "Le titre et la note sont vides"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      context.read<NoteCubit>().addNote(
                            Note(
                                id: DateTime.now().toString(),
                                hashtagsId: state.hashTagsFiltered
                                    .map((hashtag) => hashtag.id)
                                    .toList(),
                                userId: "userId",
                                title: titleController.text.trim(),
                                note: noteController.text.trim(),
                                creationDate: DateTime.now()),
                          );
                    }
                  }
                },
                hoverColor: Colors.transparent,
                child: const Icon(Icons.save),
              );
            },
          ),
          const Gap(horizontalAlign: true, gap: 10),
        ],
        elevation: 0,
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, noteState) {
          if (noteState is NotesAdded) {
            context.read<HashtagCubit>().getHashTags();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: GoogleText(text: "Note ajoutée"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, noteState) {
          return (noteState is AddingNote)
              ? const Center(
                  child: CustomProgressIndicator(),
                )
              : Padding(
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
                        BlocConsumer<HashtagCubit, HashtagState>(
                          listener: (context, hashTagState) {
                            if (hashTagState is HashTagsAdded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: GoogleText(text: "Hashtag ajouté"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          builder: (context, hashTagState) {
                            return (hashTagState is HashTagsNewGotten)
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomDropDown(
                                              list: hashTagState.hashTags,
                                              listFiltered:
                                                  hashTagState.hashTagsFiltered,
                                            ),
                                          ),
                                          const Gap(
                                              horizontalAlign: true, gap: 10),
                                          InkWell(
                                            onTap: () {
                                              pickColor(
                                                  context,
                                                  hashTagState.hashTags,
                                                  hashTagState
                                                      .hashTagsFiltered);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(4.0),
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
                                      ShowHashtags(
                                        hashtags: hashTagState.hashTags,
                                        hashtagsFiltered:
                                            hashTagState.hashTagsFiltered,
                                      ),
                                    ],
                                  )
                                : (hashTagState is GettingAllHashNewTags)
                                    ? CircularProgressIndicator(
                                        color: whiteColor,
                                      )
                                    : (hashTagState
                                            is GettingAllHashTagsNewFailed)
                                        ? Row(
                                            children: [
                                              const Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: GoogleText(
                                                      text:
                                                          "Nous n'avons pas pu récupérer vos hashtags, veuillez rééssayer"),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () => context
                                                      .read<HashtagCubit>()
                                                      .getHashTagsNew(),
                                                  icon: Icon(
                                                    Icons.download,
                                                    color: whiteColor,
                                                  ))
                                            ],
                                          )
                                        : Container();
                          },
                        ),
                        CustomTextField(
                          controller: noteController,
                          size: 15,
                          hintText: "Ajouter une note",
                          letterSpacing: false,
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future pickColor(BuildContext context, List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: blackColor,
            title: const GoogleText(
              text: "Ajouter un hashtag",
              fontWeight: true,
              fontSize: 20,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: CustomTextField(
                      controller: hashTagController,
                      size: 15,
                      hintText: "Nom du hashTag",
                      letterSpacing: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez donner un nom à votre hashtag";
                        }
                        return null;
                      },
                    ),
                  ),
                  const GoogleText(
                    text: "Choisissez une couleur !",
                    fontWeight: true,
                    fontSize: 15,
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  MaterialPicker(
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(blackColor)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => currentColor = pickerColor);
                    final String color = ColorParser.color(pickerColor).toHex();
                    context.read<HashtagCubit>().addHashTag(
                        HashTag(
                          id: DateTime.now().toString(),
                          label: hashTagController.text.trim(),
                          color: color,
                          creationDate: DateTime.now(),
                          userId: '',
                        ),
                        hashTagsList,
                        hashTagsListFiltered);
                    hashTagController.text = "";
                    Navigator.of(context).pop();
                  }
                },
                child: const GoogleText(text: "Valider"),
              ),
            ],
          );
        });
  }
}
