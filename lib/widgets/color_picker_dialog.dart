import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/theme_provider.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/translation_service.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({super.key});

  static const List<Color> colorOptions = [
    Colors.brown,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return AlertDialog(
      title: Text(
          TranslationService.translate('choose_theme_color', currentLanguage)),
      content: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: colorOptions.map((color) {
          return GestureDetector(
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setPrimaryColor(color);
              Navigator.of(context).pop();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(TranslationService.translate('cancel', currentLanguage)),
        ),
      ],
    );
  }
}
