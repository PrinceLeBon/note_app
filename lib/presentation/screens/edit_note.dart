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

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController noteController;
  final TextEditingController hashTagController = TextEditingController();
  Color currentColor = Colors.blue;
  Color pickerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    noteController = TextEditingController(text: widget.note.note);

    // Initialize hashtags with existing ones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hashtagCubit = context.read<HashtagCubit>();
      hashtagCubit.getHashTagsNew();
      // Wait for hashtags to load, then filter by existing hashtag IDs
      Future.delayed(const Duration(milliseconds: 100), () {
        if (hashtagCubit.state is HashTagsNewGotten) {
          final state = hashtagCubit.state as HashTagsNewGotten;
          final selectedHashtags = state.hashTags
              .where((hashtag) => widget.note.hashtagsId.contains(hashtag.id))
              .toList();
          hashtagCubit.setFilteredHashtags(selectedHashtags);
        }
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    hashTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () {
            context.read<HashtagCubit>().getHashTags();
            Navigator.of(context).pop();
          },
        ),
        title: const GoogleText(
          text: "Modifier la note",
          fontWeight: true,
          fontSize: 18,
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
                      // Create updated note with same ID but new content
                      final updatedNote = widget.note.copyWith(
                        title: titleController.text.trim(),
                        note: noteController.text.trim(),
                        hashtagsId: state.hashTagsFiltered
                            .map((hashtag) => hashtag.id)
                            .toList(),
                      );
                      context.read<NoteCubit>().updateNote(updatedNote);
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
          if (noteState is NoteUpdated) {
            context.read<HashtagCubit>().getHashTags();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: GoogleText(text: "Note mise à jour"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
          if (noteState is UpdatingNoteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GoogleText(text: noteState.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, noteState) {
          return (noteState is UpdatingNote)
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
                          hintText: "Modifier la note",
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
                child: GoogleText(
                  text: "Valider",
                  color: whiteColor,
                ),
              ),
            ],
          );
        });
  }
}
