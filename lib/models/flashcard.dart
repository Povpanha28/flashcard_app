import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final bool isKnown;

  Flashcard({
    String? id,
    required this.question,
    required this.answer,
    this.isKnown = false,
  }) : id = id ?? const Uuid().v4();

  Flashcard copyWith({String? question, String? answer, bool? isKnown}) {
    return Flashcard(
      id: id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isKnown: isKnown ?? this.isKnown,
    );
  }

  Flashcard ToggleKnown() {
    return Flashcard(
      id: id,
      question: question,
      answer: answer,
      isKnown: !isKnown,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'isKnown': isKnown,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      isKnown: json['isKnown'] as bool? ?? false,
    );
  }
}
