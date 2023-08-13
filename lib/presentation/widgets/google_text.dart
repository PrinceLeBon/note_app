import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleText extends StatelessWidget {
  final String text;
  final bool fontWeight;
  final double fontSize;
  final Color? color;

  const GoogleText(
      {super.key,
      required this.text,
      this.fontWeight = false,
      this.fontSize = 14,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight ? FontWeight.w600 : null,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
