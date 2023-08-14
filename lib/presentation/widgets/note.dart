import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/utils/constants.dart';
import '../../data/models/hashtag.dart';
import '../../data/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
              ),
              const Gap(horizontalAlign: false, gap: 10),
            ],
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
