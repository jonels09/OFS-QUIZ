import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _reminderKey = 'reminder_frequency';

  Future<void> setReminderFrequency(int hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reminderKey, hours);
  }

  Future<int> getReminderFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_reminderKey) ?? 24; // Par défaut: une fois par jour
  }
}
