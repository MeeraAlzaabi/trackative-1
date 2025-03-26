import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class CommunityService {
  final dbHelper = DBHelper.instance;

  Future<List<Map<String, dynamic>>> getCommunities() async {
    final db = await dbHelper.database;
    return await db.query('communities');
  }

  Future<void> joinCommunity(int userId, int communityId) async {
    final db = await dbHelper.database;
    await db.insert(
      'user_communities',
      {'userId': userId, 'communityId': communityId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getUserCommunities(int userId) async {
    final db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT c.* FROM communities c
      INNER JOIN user_communities uc ON c.id = uc.communityId
      WHERE uc.userId = ?
    ''', [userId]);
  }
}
