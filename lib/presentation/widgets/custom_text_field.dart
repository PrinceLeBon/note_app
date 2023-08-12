import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double size;
  final String hintText;
  final bool letterSpacing;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.size,
      required this.hintText,
      required this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: whiteColor,
      controller: controller,
      minLines: 1,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: size,
        color: whiteColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacing ? 2 : null,
          fontSize: size,
          color: const Color(0xff848181),
        ),
        contentPadding: const EdgeInsets.only(
          top: 15.5,
          right: 13.65,
          bottom: 15.5,
          left: 16.0,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
