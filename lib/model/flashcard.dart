import 'package:flutter/material.dart';

class Flashcard {
  int id;
  String question;
  String answer;

  Flashcard({required this.id, required this.question, required this.answer});
}

class Deck{
  int id;
  String name;
  List<Flashcard> flashcards;
  IconData? icon;
  Color? color;
  Deck({required this.id, required this.name, required this.flashcards, this.icon, this.color});
}
