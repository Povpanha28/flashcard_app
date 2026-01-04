import 'package:flashcard_app/models/deck.dart';
import 'package:uuid/uuid.dart';

class StudySession {
  final String id;
  final int correctCount;
  final int wrongCount;
  final Deck deck;

  StudySession({
    required this.correctCount,
    required this.wrongCount,
    required this.deck,
  }) : id = const Uuid().v4();
}
