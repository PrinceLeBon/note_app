import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final String title;
  final String label;

  const Note({super.key, required this.title, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 10,
            ),
            Text(label),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
