import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const CustomProgressIndicator({super.key, this.color, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    // Use provided color, or default to theme's primary color
    final indicatorColor = color ?? Theme.of(context).colorScheme.primary;
    
    return Center(
      child: SpinKitChasingDots(
        color: indicatorColor,
        size: size,
      ),
    );
  }
}
