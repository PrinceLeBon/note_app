import 'package:flutter/material.dart';
import 'package:note_app/presentation/screens/homepage.dart';
import 'package:note_app/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: blackColor,
        appBarTheme: AppBarTheme(
          color: blackColor,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: whiteColor,
              displayColor: whiteColor,
            ),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyHomePage(),
    );
  }
}
