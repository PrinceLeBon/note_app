import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/data/models/hashtag.dart';
import '../../utils/constants.dart';
import 'gap.dart';

class TempHashTag extends StatelessWidget {
  final HashTag hashtag;

  const TempHashTag({
    super.key,
    required this.hashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4.0,
        right: 8.0,
        bottom: 4.0,
        left: 6.0,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Icon(
              Icons.close,
              color: hexToColor(hashtag.color),
              size: 14.0,
            ),
          ),
          const Gap(
            gap: 3.5,
            horizontalAlign: true,
          ),
          Text(
            hashtag.label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: blackColor,
            ),
          )
        ],
      ),
    );
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
