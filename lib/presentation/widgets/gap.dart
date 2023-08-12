import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final bool horizontalAlign;
  final double gap;

  const Gap({super.key, required this.horizontalAlign, required this.gap});

  @override
  Widget build(BuildContext context) {
    return horizontalAlign ? Container(width: gap) : Container(height: gap);
  }
}
