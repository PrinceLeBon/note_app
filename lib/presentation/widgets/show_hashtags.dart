import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/tem_hashtag.dart';
import 'package:note_app/utils/constants.dart';

class ShowHashtags extends StatelessWidget {
  final List<String> hashtags;

  const ShowHashtags({super.key, required this.hashtags});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: hashtags.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(horizontalAlign: true, gap: 10),
          SizedBox(
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hashtags.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                  right: 11.0,
                ),
                child: InkWell(
                  onTap: null,
                  child: TempHashTag(hashtag: hashtags[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
