import 'package:flutter/material.dart';
import 'package:note_app/presentation/widgets/google_text.dart';

class Note extends StatelessWidget {
  final String title;
  final String label;

  const Note({super.key, required this.title, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 10,
              ),
              GoogleText(
                text: title,
                fontWeight: true,
              ),
              Container(
                height: 10,
              ),
              GoogleText(text: label),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
