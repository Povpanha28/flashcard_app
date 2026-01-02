import 'package:flashcard_app/models/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Deck {
  final String id;
  final String title;
  final String description;
  final List<Flashcard> cards;
  final IconData? icon;
  final Color? color;


  Deck({required this.title, required this.description, required this.cards, this.icon = Icons.flash_auto, this.color = Colors.blue})
    : id = const Uuid().v4();

  void addCard(Flashcard newCard) {
    cards.add(newCard);
  }

  void removeCard(String cardId) {
    cards.removeWhere((card) => card.id == cardId);
  }
}
