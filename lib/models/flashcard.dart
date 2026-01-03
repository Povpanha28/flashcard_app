import 'package:flashcard_app/models/progress.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Flashcard {
  final String id;
  final String question;
  final String answer;
  

  Flashcard({required this.question, required this.answer})
    : id = const Uuid().v4();
}
