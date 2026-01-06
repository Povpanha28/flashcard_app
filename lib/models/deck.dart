import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/models/progress.dart';
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
  final Progress? progress;

  Deck({
    String? id,
    required this.title,
    required this.description,
    List<Flashcard>? cards,
    this.icon = Icons.flash_auto,
    this.color = Colors.blue,
    this.progress,
  }) : id = id ?? const Uuid().v4(),
       cards = cards ?? [];

  void addCard(Flashcard newCard) {
    cards.add(newCard);
  }

  void insertCard(int index, Flashcard card) {
    if (index >= 0 && index <= cards.length) {
      cards.insert(index, card);
    } else {
      cards.add(card);
    }
  }

  void removeCard(String cardId) {
    cards.removeWhere((card) => card.id == cardId);
  }

  void updateFlashcard(String cardId, Flashcard updatedCard) {
    int index = cards.indexWhere((card) => card.id == cardId);
    if (index != -1) {
      cards[index] = updatedCard;
    }
  }

  Deck copyWith({
    String? id,
    String? title,
    String? description,
    List<Flashcard>? cards,
    IconData? icon,
    Color? color,
    Progress? progress,
  }) {
    return Deck(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cards: cards ?? this.cards,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cards': cards.map((card) => card.toJson()).toList(),
      'iconCodePoint': icon?.codePoint,
      'colorValue': color?.value,
      'progress': progress?.toJson(),
    };
  }

  factory Deck.fromJson(Map<String, dynamic> json) {
    final iconCodePoint = json['iconCodePoint'] as int?;
    final colorValue = json['colorValue'] as int?;

    return Deck(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map((c) => Flashcard.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      icon: iconCodePoint != null
          ? IconData(iconCodePoint, fontFamily: 'MaterialIcons')
          : Icons.flash_auto,
      color: colorValue != null ? Color(colorValue) : Colors.blue,
      progress: json['progress'] != null
          ? Progress.fromJson(json['progress'] as Map<String, dynamic>)
          : null,
    );
  }
}
