import 'package:flutter/material.dart';
import 'package:note_app/presentation/screens/firstpage.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import '../../utils/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: whiteColor,
        ),
        title: const GoogleText(text: "Hi, Prince Le Bon"),
        elevation: 0,
        actions: [
          const Icon(Icons.search),
          Container(
            width: 10,
          )
        ],
      ),
      body: const FirstPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: whiteColor,
        onPressed: null,
        child: Icon(
          Icons.add,
          color: blackColor,
        ),
      ),
    );
  }
}
