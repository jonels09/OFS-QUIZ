import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/translation_service.dart';
import 'package:quiz_app/widgets/color_picker_dialog.dart';
import 'package:quiz_app/widgets/reminder_dialog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.brown,
              ),
            ),
            accountName: const Text('Quiz Franciscain'),
            accountEmail: const Text('quiz@franciscain.org'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
                TranslationService.translate('notifications', currentLanguage)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => const ReminderDialog(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(TranslationService.translate(
                'change_language', currentLanguage)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(TranslationService.translate(
                      'select_language', currentLanguage)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Français'),
                        onTap: () {
                          languageProvider.setLanguage('fr');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Malagasy'),
                        onTap: () {
                          languageProvider.setLanguage('mg');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(
                TranslationService.translate('change_theme', currentLanguage)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => const ColorPickerDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(TranslationService.translate('about', currentLanguage)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                      TranslationService.translate('about', currentLanguage)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(TranslationService.translate(
                          'about_content', currentLanguage)),
                      const SizedBox(height: 16),
                      const Text('Version 1.0.0'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(TranslationService.translate(
                          'close', currentLanguage)),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
