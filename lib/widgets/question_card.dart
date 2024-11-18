import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/providers/language_provider.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(bool) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late List<Answer> _shuffledAnswers;
  int? _selectedAnswerIndex;
  bool _isAnswerLocked = false;

  @override
  void initState() {
    super.initState();
    _shuffleAnswers();
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _shuffleAnswers();
      _selectedAnswerIndex = null;
      _isAnswerLocked = false;
    }
  }

  void _shuffleAnswers() {
    _shuffledAnswers = List.from(widget.question.answers);
    _shuffledAnswers.shuffle();
  }

  Color _getButtonColor(BuildContext context, int index) {
    if (_selectedAnswerIndex != index) {
      return Theme.of(context).cardColor;
    }
    if (!_isAnswerLocked) {
      return Theme.of(context).primaryColor.withOpacity(0.3);
    }
    return _shuffledAnswers[index].isCorrect
        ? Colors.green.shade100
        : Colors.red.shade100;
  }

  Color _getBorderColor(BuildContext context, int index) {
    if (_selectedAnswerIndex != index) {
      return Theme.of(context).primaryColor.withOpacity(0.2);
    }
    if (!_isAnswerLocked) {
      return Theme.of(context).primaryColor;
    }
    return _shuffledAnswers[index].isCorrect ? Colors.green : Colors.red;
  }

  void _handleAnswer(int index) {
    if (_isAnswerLocked) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswerLocked = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onAnswerSelected(_shuffledAnswers[index].isCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Text(
            widget.question.text[currentLanguage] ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _shuffledAnswers.length,
            itemBuilder: (context, index) {
              final answer = _shuffledAnswers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed:
                      _isAnswerLocked ? null : () => _handleAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(context, index),
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                      color: _getBorderColor(context, index),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    answer.text[currentLanguage] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
