import 'package:flutter/material.dart';
import 'package:to_do_list/util/entry_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // app bar //
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 83, 120, 255),
          title: const Text(
            'September 13',
            style: TextStyle(
              color: Colors.white, // Set the text color here
              fontSize: 20, // Optionally, adjust the font size
            ),
          ),
        ),

      body: ListView(
        children: [
          EntryTile(title: 'Finish Introduction to Cybersecurity', isCompleted: false,),
        ]
      ),
      ),
    );
  }
}
