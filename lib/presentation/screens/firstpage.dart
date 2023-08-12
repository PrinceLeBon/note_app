import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/hashtags.dart';
import 'package:note_app/presentation/widgets/note.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const GoogleText(
              text: "My Notes",
              fontSize: 50,
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 105,
                  itemBuilder: (context, index) {
                    return Hashtags(
                      label: index.toString(),
                    );
                  }),
            ),
            Container(
              width: 10,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return Note(
                    title: index.toString(),
                    label: index.toString(),
                  );
                })
          ],
        ),
      ),
    );
  }
}
