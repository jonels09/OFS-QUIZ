import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/question.dart';

class QuestionService {
  Future<List<Question>> loadQuestions() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/questions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonData['questions'];

      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }
}
