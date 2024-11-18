import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String value) {
        Provider.of<LanguageProvider>(context, listen: false)
            .setLanguage(value);
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'fr',
          child: Text('Français'),
        ),
        const PopupMenuItem(
          value: 'mg',
          child: Text('Malagasy'),
        ),
      ],
    );
  }
}
