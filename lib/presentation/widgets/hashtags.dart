import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/utils/constants.dart';
import '../../data/models/hashtag.dart';

class Hashtags extends StatelessWidget {
  final HashTag hashtag;

  const Hashtags({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Chip(
        label: GoogleText(
          text: "#${hashtag.label}",
          color: blackColor,
        ),
        backgroundColor: hexToColor(hashtag.color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.transparent)),
      ),
    );
  }
}
