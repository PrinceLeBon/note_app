import 'package:flutter/material.dart';
import 'package:note_app/presentation/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF131313),
          appBarTheme: const AppBarTheme(
            color: Color(0xFF131313),
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              )),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyHomePage(),
    );
  }
}
