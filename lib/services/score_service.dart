import 'dart:convert';
import 'package:quiz_app/models/score.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const String _key = 'quiz_scores';

  Future<void> saveScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scores = prefs.getStringList(_key) ?? [];
    scores.add(jsonEncode(score.toJson()));
    await prefs.setStringList(_key, scores);
  }

  Future<List<Score>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scores = prefs.getStringList(_key) ?? [];
    return scores.map((score) => Score.fromJson(jsonDecode(score))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
