import 'package:trackactive/models/habit.dart';
import 'package:trackactive/services/db_helper.dart';

class HabitService {
  final dbHelper = DBHelper.instance;

  Future<void> addHabit(HabitModel habit) async {
    final db = await dbHelper.database;
    await db.insert('habits', habit.toMap());
  }

  // Future<List<HabitModel>> getHabitsByUserId(int userId) async {
  //   final db = await dbHelper.database;
  //   final result = await db.query(
  //     'habits',
  //     where: 'userId = ?',
  //     whereArgs: [userId],
  //   );
  //   return result.map((map) => HabitModel.fromMap(map)).toList();
  // }

  // Method to update an existing habit
  Future<void> updateHabit(HabitModel habit) async {
    final db = await dbHelper.database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id], // assuming each habit has a unique ID
    );
  }
}
