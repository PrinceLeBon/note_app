import 'package:flutter/material.dart';

Color blackColor = const Color(0xFF131313);
Color whiteColor = Colors.white;

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}