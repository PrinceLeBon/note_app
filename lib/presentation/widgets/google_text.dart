import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleText extends StatelessWidget {
  final String text;
  final bool fontWeight;
  final double fontSize;
  final Color? color;
  final bool card;

  const GoogleText({
    super.key,
    required this.text,
    this.fontWeight = false,
    this.fontSize = 14,
    this.color,
    this.card = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight ? FontWeight.w600 : null,
        fontSize: fontSize,
        color: color,
      ),
      overflow: card ? TextOverflow.ellipsis : null,
      maxLines: card ? 1 : null,
    );
  }

  static TextStyle getStyle({
    bool fontWeight = false,
    double fontSize = 14,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontWeight: fontWeight ? FontWeight.w600 : null,
      fontSize: fontSize,
      color: color,
    );
  }
}
