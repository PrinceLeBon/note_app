import 'package:flutter/material.dart';
import 'google_text.dart';

class CustomSnackBar {
  final String content;
  final bool isError;
  final BuildContext context;

  const CustomSnackBar({
    required this.content,
    this.isError = false,
    required this.context,
  });

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(returnSnackBar(
      content: content,
      isError: isError,
    ));
  }

  SnackBar returnSnackBar({
    bool isError = false,
    required String content,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(10),
      backgroundColor: isError ? Colors.red : Colors.white,
      content: GoogleText(
        text: content,
        color: Colors.black,
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
