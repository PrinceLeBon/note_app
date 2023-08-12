import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/google_text.dart';

class Hashtags extends StatelessWidget {
  final String label;

  const Hashtags({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: GoogleText(text: "# $label"));
  }
}
