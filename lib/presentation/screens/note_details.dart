import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/hashtags.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/hashtag.dart';

class NoteView extends StatelessWidget {
  final Note note;

  const NoteView({super.key, required this.note});

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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoogleText(
                text: note.title.isEmpty ? "Sans titre" : note.title,
                fontSize: 40,
                fontWeight: true,
              ),
              const Gap(horizontalAlign: false, gap: 10),
              Wrap(
                children: getHashTags(note.hashtagsId)
                    .map((hashtag) => Hashtags(hashtag: hashtag))
                    .toList(),
              ),
              const Gap(horizontalAlign: false, gap: 10),
              SelectableLinkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url),
                      mode: LaunchMode.externalNonBrowserApplication)) {
                    throw Exception('Could not launch ${link.url}');
                  }
                },
                options: const LinkifyOptions(humanize: false),
                text: note.note.isEmpty ? "Aucun contenu" : note.note,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<HashTag> getHashTags(List<String> hashTagsId) {
  if (hashTagsId.isEmpty) {
    return [];
  }
  final Box noteBox = Hive.box("Notes");
  return List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
      .cast<HashTag>()
      .where((hashtag) => hashTagsId.contains(hashtag.id))
      .toList();
}
