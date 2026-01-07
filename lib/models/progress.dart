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

  Progress copyWith({int? reviewedCount, DateTime? lastReviewed}) {
    return Progress(
      reviewedCount: reviewedCount ?? this.reviewedCount,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }

  /// Increment the review count and update last reviewed time
  Progress incrementReview() {
    return Progress(
      reviewedCount: reviewedCount + 1,
      lastReviewed: DateTime.now(),
    );
  }

  String formatLastReviewed(DateTime? lastReviewed) {
    if (lastReviewed == null) return 'Never reviewed';

    final now = DateTime.now();
    final difference = now.difference(lastReviewed);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
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
