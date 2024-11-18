import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/score.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/translation_service.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  List<Score> _getTopScores(List<Score> scores, String category) {
    final categoryScores =
        scores.where((score) => score.category == category).toList();

    categoryScores.sort((a, b) =>
        (b.score / b.totalQuestions).compareTo(a.score / a.totalQuestions));

    return categoryScores.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scoreService = ScoreService();
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;
    final categories = ['vie_saint_francois', 'bible'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            TranslationService.translate('score_history', currentLanguage)),
      ),
      body: FutureBuilder<List<Score>>(
        future: scoreService.getScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                  TranslationService.translate('no_scores', currentLanguage)),
            );
          }

          return PageView.builder(
            itemCount: categories.length,
            itemBuilder: (context, categoryIndex) {
              final category = categories[categoryIndex];
              final categoryScores = _getTopScores(snapshot.data!, category);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      TranslationService.translate(
                          'category_$category', currentLanguage),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  if (categoryScores.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          TranslationService.translate(
                              'no_scores_category', currentLanguage),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: categoryScores.length,
                        itemBuilder: (context, index) {
                          final score = categoryScores[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${score.score}/${score.totalQuestions} (${(score.score / score.totalQuestions * 100).round()}%)',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(score.date),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
