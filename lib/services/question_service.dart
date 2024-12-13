import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/question.dart';

class QuestionService {
  Future<List<Question>> loadQuestions() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/questions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      if (jsonData['questions'] == null || jsonData['questions'].isEmpty) {
        throw Exception('Aucune question trouvée dans le fichier JSON.');
      }

      return (jsonData['questions'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
    } catch (e) {
      print('Erreur lors du chargement des questions : $e');
      return [];
    }
  }

  List<Question> filterQuestionsByLevel(List<Question> questions, int level) {
    return questions.where((question) => question.difficulty == level).toList();
  }
}
