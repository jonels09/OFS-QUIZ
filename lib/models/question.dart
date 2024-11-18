import 'package:quiz_app/models/answer.dart';

class Question {
  final String id;
  final Map<String, String> text;
  final List<Answer> answers;
  final String? imageUrl;
  final String category;
  final int difficulty;

  const Question({
    required this.id,
    required this.text,
    required this.answers,
    this.imageUrl,
    required this.category,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: Map<String, String>.from(json['text'] as Map),
      answers: (json['answers'] as List)
          .map((answer) => Answer.fromJson(answer as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
    );
  }
}
