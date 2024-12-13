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

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  List<Question> _questions = [];
  final QuestionService _questionService = QuestionService();
  final ScoreService _scoreService = ScoreService();
  final GlobalKey<QuizTimerState> _timerKey = GlobalKey<QuizTimerState>();

  int _level = 1; // Niveau actuel
  int _level1QuestionCount = 0; // Compteur pour les questions de niveau 1

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Chargement initial des questions
  }

  Future<void> _loadQuestions() async {
    try {
      final allQuestions = await _questionService
          .loadQuestions(); // Charger toutes les questions
      List<Question> level1Questions = allQuestions
          .where((q) => q.difficulty == 1 && q.category == widget.category)
          .toList(); // Filtrer les questions de niveau 1 pour la catégorie choisie
      List<Question> otherLevelQuestions = allQuestions
          .where((q) => q.difficulty > 1 && q.category == widget.category)
          .toList(); // Filtrer les autres niveaux

      level1Questions.shuffle(); // Mélanger les questions de niveau 1

      // Limiter à 10 premières questions de niveau 1
      List<Question> selectedQuestions = level1Questions.take(10).toList();

      // Ajouter des questions d'autres niveaux aléatoirement après avoir répondu à 10 questions de niveau 1
      if (selectedQuestions.length == 10) {
        selectedQuestions
            .addAll(otherLevelQuestions); // Ajouter toutes les autres questions
        selectedQuestions
            .shuffle(); // Mélanger toutes les questions sélectionnées
      }

      setState(() {
        _questions =
            selectedQuestions; // Mettre à jour l'état avec les questions chargées
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erreur de chargement des questions. Veuillez réessayer.')),
      );
    }
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
        if (_level == 1) {
          _level1QuestionCount++; // Incrémenter le compteur pour le niveau 1
          if (_level1QuestionCount >= 10) {
            // Passer au niveau suivant après avoir répondu à 10 questions de niveau 1
            _level++;
            _level1QuestionCount =
                0; // Réinitialiser le compteur pour le prochain niveau
          }
        }

        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _timerKey.currentState
              ?.resetTimer(); // Réinitialiser le timer pour la prochaine question
        } else {
          _finishQuiz(); // Terminer le quiz si c'était la dernière question
        }
      });
    } else {
      _finishQuiz(); // Terminer le quiz si la réponse est incorrecte
    }
  }

  void _finishQuiz() {
    setState(() {
      _isQuizFinished = true; // Marquer le quiz comme terminé
    });
    _saveScore(); // Sauvegarder le score dans le service de score
    _showScoreDialog(); // Afficher le dialogue de score à l'utilisateur
  }

  void _showScoreDialog() {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLanguage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>
              false, // Empêcher la fermeture du dialogue avec le bouton retour
          child: AlertDialog(
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
                  Navigator.of(context).pop(); // Retourner à l'écran précédent
                },
                child: Text(
                    TranslationService.translate('back_home', currentLanguage)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer le dialogue actuel
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizScreen(category: widget.category)),
                  );
                },
                child: Text(
                    TranslationService.translate('restart', currentLanguage)),
              ),
            ],
          ),
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
    await _scoreService
        .saveScore(score); // Sauvegarder le score dans le service de score
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Indicateur de chargement pendant que les questions sont récupérées
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async =>
          false, // Empêcher la fermeture accidentelle du quiz avec le bouton retour en arrière
      child: Scaffold(
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
                  child: Center(
                    child: QuizTimer(key: _timerKey, onTimeUp: _finishQuiz),
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
      ),
    );
  }
}
