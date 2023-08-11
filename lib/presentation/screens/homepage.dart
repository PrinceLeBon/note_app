import 'package:flutter/material.dart';
import 'package:note_app/presentation/screens/firstpage.dart';

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
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
        ),
        title: const Text("Hi, Prince Le Bon"),
        elevation: 0,
        actions: [
          const Icon(Icons.search),
          Container(
            width: 10,
          )
        ],
      ),
      body: const FirstPage(),
      floatingActionButton: const FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: null,
        child: Icon(
          Icons.add,
          color: Color(0xFF131313),
        ),
      ),
    );
  }
}
