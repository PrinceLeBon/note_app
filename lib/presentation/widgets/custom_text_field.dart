import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double size;
  final String hintText;
  final bool letterSpacing;
  final bool password;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.size,
      this.validator,
      this.onChanged,
      this.password = false,
      required this.hintText,
      required this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: TextInputType.multiline,
      maxLines: (password) ? 1 : null,
      cursorColor: Theme.of(context).brightness == Brightness.light
          ? Colors.black87
          : whiteColor,
      controller: controller,
      minLines: 1,
      obscureText: password,
      obscuringCharacter: "*",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: size,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black87
            : whiteColor,
      ),
      onChanged: onChanged,
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
