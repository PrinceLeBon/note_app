import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/utils/constants.dart';

class Hashtags extends StatelessWidget {
  final String label;

  const Hashtags({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Chip(
        label: GoogleText(text: "#$label"),
        backgroundColor: whiteColor,
      ),
    );
  }
}
