import 'package:flutter/material.dart';

class Hashtags extends StatelessWidget {
  final String label;

  const Hashtags({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text("# $label"));
  }
}
