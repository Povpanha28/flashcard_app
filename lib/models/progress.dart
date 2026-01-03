class Progress {
  final int knownCard;
  final int unknownCard;

  Progress({required this.knownCard, required this.unknownCard});

  double get mastery {
    final total = knownCard + unknownCard;
    if (total == 0) return 0.0;
    return (knownCard / total) * 100;
  }

  Map<String, dynamic> toJson() {
    return {'knownCard': knownCard, 'unknownCard': unknownCard};
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      knownCard: json['knownCard'] as int? ?? 0,
      unknownCard: json['unknownCard'] as int? ?? 0,
    );
  }
}
