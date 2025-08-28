import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/presentation/screens/note_details.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/utils/constants.dart';
import '../../data/models/hashtag.dart';
import '../../data/models/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/presentation/screens/edit_note.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
              onPressed: (context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(note: note),
                  ),
                );
              },
              backgroundColor: Colors.grey.shade800,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12)),
          SlidableAction(
              onPressed: (context) =>
                  context.read<NoteCubit>().deleteNote(note.id),
              backgroundColor: Colors.grey.shade800,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12))
        ]),
        child: InkWell(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NoteView(note: note);
          })),
          child: Container(
            decoration: BoxDecoration(
              color: getColorOfCard(note.hashtagsId),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Gap(horizontalAlign: false, gap: 10),
                  GoogleText(
                    text: note.title.isEmpty ? "Sans titre" : note.title,
                    fontWeight: true,
                    color: Colors.black,
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  GoogleText(
                    text: note.note.isEmpty ? "Aucun contenu" : note.note,
                    color: Colors.black,
                    card: true,
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color getColorOfCard(List<String> hashTagsId) {
  if (hashTagsId.isEmpty) {
    return Colors.grey;
  }
  final Box noteBox = Hive.box("Notes");
  HashTag result = List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
      .cast<HashTag>()
      .where((hashtag) => hashtag.id == hashTagsId[0])
      .toList()[0];
  return hexToColor(result.color);
}
