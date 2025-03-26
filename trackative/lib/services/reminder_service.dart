import 'package:trackactive/models/reminder.dart';
import 'package:trackactive/services/db_helper.dart'; // Your database helper

class ReminderService {
  final dbHelper = DBHelper.instance;

  Future<void> addReminder(Reminder reminder) async {
    await dbHelper.insertReminder(reminder);
  }

  Future<List<Reminder>> getRemindersForUser(int userId) async {
    final maps = await dbHelper.queryReminders(userId);
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }
}
