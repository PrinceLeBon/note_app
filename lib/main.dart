import 'package:flutter/material.dart';
import 'package:note_app/presentation/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF131313),
          onPrimary: Color(0xFF131313),
          secondary: Color(0xFF131313),
          onSecondary: Color(0xFF131313),
          error: Colors.red,
          onError: Colors.red,
          background: Color(0xFF131313),
          onBackground: Color(0xFF131313),
          surface: Color(0xFF131313),
          onSurface: Color(0xFF131313),
        ),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyHomePage(),
    );
  }
}
