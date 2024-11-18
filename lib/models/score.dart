class Score {
  final int score;
  final int totalQuestions;
  final DateTime date;
  final String category;

  const Score({
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.category,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
