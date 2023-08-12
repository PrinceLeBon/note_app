import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import 'gap.dart';

class TempHashTag extends StatelessWidget {
  final String hashtag;

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
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 14.0,
            ),
          ),
          const Gap(
            gap: 3.5,
            horizontalAlign: true,
          ),
          Text(
            hashtag,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: const Color(0xff737373),
            ),
          )
        ],
      ),
    );
  }
}
