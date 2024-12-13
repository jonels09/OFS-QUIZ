import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/score.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/translation_service.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Score> _getTopScores(List<Score> scores, String category) {
    final categoryScores =
        scores.where((score) => score.category == category).toList();
    categoryScores.sort((a, b) => b.score.compareTo(a.score));
    return categoryScores.take(10).toList();
  }

  Widget _buildScoreCard(Score score, BuildContext context, int rank) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            '${rank + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${score.score} points',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy HH:mm').format(score.date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildCategoryPage(
      String category, List<Score> scores, String currentLanguage) {
    final categoryScores = _getTopScores(scores, category);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
      child: Column(
        children: [
          /*Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child:*/
          Text(
            TranslationService.translate('category_$category', currentLanguage),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          //),
          Expanded(
            child: categoryScores.isEmpty
                ? Center(
                    child: Text(
                    TranslationService.translate(
                        'no_scores_category', currentLanguage),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: categoryScores.length,
                    itemBuilder: (context, index) {
                      return _buildScoreCard(
                          categoryScores[index], context, index);
                    },
                  ),
          ),
        ],
      ),
    );
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
                child: Text(TranslationService.translate(
                    'no_scores', currentLanguage)));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: categories.length,
            itemBuilder: (context, categoryIndex) {
              final category = categories[categoryIndex];
              return _buildCategoryPage(
                  category, snapshot.data!, currentLanguage);
            },
          );
        },
      ),
    );
  }
}
