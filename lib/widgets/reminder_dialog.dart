import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/language_provider.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/translation_service.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({super.key});

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final _notificationService = NotificationService();
  int _selectedHours = 24;

  @override
  void initState() {
    super.initState();
    _loadCurrentFrequency();
  }

  Future<void> _loadCurrentFrequency() async {
    final hours = await _notificationService.getReminderFrequency();
    setState(() {
      _selectedHours = hours;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return AlertDialog(
      title: Text(
          TranslationService.translate('reminder_settings', currentLanguage)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(TranslationService.translate(
              'reminder_description', currentLanguage)),
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: _selectedHours,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: 12,
                child: Text(TranslationService.translate(
                    'reminder_12h', currentLanguage)),
              ),
              DropdownMenuItem(
                value: 24,
                child: Text(TranslationService.translate(
                    'reminder_24h', currentLanguage)),
              ),
              DropdownMenuItem(
                value: 48,
                child: Text(TranslationService.translate(
                    'reminder_48h', currentLanguage)),
              ),
              DropdownMenuItem(
                value: 72,
                child: Text(TranslationService.translate(
                    'reminder_72h', currentLanguage)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedHours = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(TranslationService.translate('cancel', currentLanguage)),
        ),
        TextButton(
          onPressed: () async {
            await _notificationService.setReminderFrequency(_selectedHours);
            if (mounted) Navigator.pop(context);
          },
          child: Text(TranslationService.translate('save', currentLanguage)),
        ),
      ],
    );
  }
}
