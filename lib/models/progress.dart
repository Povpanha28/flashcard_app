enum MasterLevel {
  veryconfident,
  confident,
  neutral,
  lowconfidence,
  unconfident,
}

class Progress {
  MasterLevel masterLevel;
  final double mastery;
  final double? lastReviewed;
  final double? timesReviewed;

  Progress({required this.masterLevel, this.mastery = 0, this.lastReviewed, this.timesReviewed});
}
