import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/scores_screen.dart';
import 'package:quiz_app/services/translation_service.dart';
import 'package:quiz_app/widgets/language_selector.dart';
import 'package:quiz_app/widgets/theme_toggle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.translate('app_title', currentLanguage)),
        actions: const [
          ThemeToggle(),
          LanguageSelector(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              TranslationService.translate('select_category', currentLanguage),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildCategoryCard(
              context,
              title: TranslationService.translate(
                  'category_vie_saint_francois', currentLanguage),
              category: 'vie_saint_francois',
              color: const Color(0xFFFFE8E8),
              icon: Icons.church,
              iconColor: Colors.pink,
            ),
            const SizedBox(height: 16),
            _buildCategoryCard(
              context,
              title: TranslationService.translate(
                  'category_bible', currentLanguage),
              category: 'bible',
              color: const Color(0xFFE8F1FF),
              icon: Icons.auto_stories,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScoresScreen()),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: const Color(0xFFE8FFE9),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          TranslationService.translate(
                              'view_scores', currentLanguage),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String category,
    required Color color,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
