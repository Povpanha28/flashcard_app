import 'package:flashcard_app/ui/screens/decks/decks.dart';
import 'package:flashcard_app/ui/screens/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Decks()),
    );
  }
}