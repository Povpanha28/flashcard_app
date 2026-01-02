import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flutter/material.dart';

final List<Deck> mockDecks = [
  Deck(
    title: 'Spanish Basics',
    description: 'Common phrases and vocabulary in Spanish.',
    icon: Icons.language,
    color: const Color(0xFFFF6B6B),
    cards: [
      Flashcard(question: 'Hello', answer: 'Hola'),
      Flashcard(question: 'Thank you', answer: 'Gracias'),
      Flashcard(question: 'Please', answer: 'Por favor'),
    ],
  ),
  Deck(
    title: 'Math Formulas',
    description: 'Essential math formulas for quick reference.',
    icon: Icons.calculate,
    color: const Color(0xFF4ECDC4),
    cards: [
      Flashcard(question: 'Area of a Circle', answer: 'A = πr²'),
      Flashcard(question: 'Pythagorean Theorem', answer: 'a² + b² = c²'),
      Flashcard(
        question: 'Quadratic Formula',
        answer: 'x = [-b ± √(b²-4ac)] / 2a',
      ),
    ],
  ),
];
