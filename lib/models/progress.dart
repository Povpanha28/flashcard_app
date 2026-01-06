import 'package:flashcard_app/models/flashcard.dart';

class Progress {
  final int reviewedCount;
  final DateTime lastReviewed;

  Progress({this.reviewedCount = 0, DateTime? lastReviewed})
    : lastReviewed = lastReviewed ?? DateTime.now();

  int getKnownCount(List<Flashcard> cards) {
    return cards.where((card) => card.isKnown).length;
  }

  int getTotalCount(List<Flashcard> cards) {
    return cards.length;
  }

  double getMastery(int knownCard, int totalCard) {
    if (totalCard == 0) return 0.0;
    return knownCard / totalCard;
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewedCount': reviewedCount,
      'lastReviewed': lastReviewed.toIso8601String(),
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      reviewedCount: json['reviewedCount'] as int? ?? 0,
      lastReviewed: json['lastReviewed'] != null
          ? DateTime.parse(json['lastReviewed'] as String)
          : null,
    );
  }
}
