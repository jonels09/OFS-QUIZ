class Answer {
  final Map<String, String> text;
  final bool isCorrect;

  const Answer({
    required this.text,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: Map<String, String>.from(json['text'] as Map),
      isCorrect: json['isCorrect'] as bool,
    );
  }
}
