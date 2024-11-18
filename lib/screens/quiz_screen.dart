import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/score.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/translation_service.dart';
import 'package:quiz_app/widgets/quiz_timer.dart';
import 'package:quiz_app/widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  List<Question> _questions = [];
  final _questionService = QuestionService();
  final _scoreService = ScoreService();
  final _timerKey = GlobalKey<QuizTimerState>();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _questionService.loadQuestions();
    final categoryQuestions =
        questions.where((q) => q.category == widget.category).toList();
    categoryQuestions.shuffle();

    setState(() {
      _questions = categoryQuestions;
    });
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }
    _finishQuiz();
  }

  void _finishQuiz() {
    setState(() {
      _isQuizFinished = true;
    });
    _saveScore();
    _showScoreDialog();
  }

  void _showScoreDialog() {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLanguage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              TranslationService.translate('quiz_finished', currentLanguage)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${TranslationService.translate('final_score', currentLanguage)}: $_score/${_questions.length}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                '${TranslationService.translate('percentage', currentLanguage)}: ${(_score / _questions.length * 100).round()}%',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                  TranslationService.translate('back_home', currentLanguage)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(category: widget.category),
                  ),
                );
              },
              child: Text(
                  TranslationService.translate('restart', currentLanguage)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveScore() async {
    final score = Score(
      score: _score,
      totalQuestions: _questions.length,
      date: DateTime.now(),
      category: widget.category,
    );
    await _scoreService.saveScore(score);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    QuizTimer(
                      key: _timerKey,
                      onTimeUp: _finishQuiz,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: QuestionCard(
                    question: _questions[_currentQuestionIndex],
                    onAnswerSelected: _handleAnswer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
