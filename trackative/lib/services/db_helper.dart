import 'package:sqflite/sqflite.dart';
import 'package:trackactive/models/reminder.dart';
import '../models/user.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habit_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(
      filePath,
      version: 2, // Increment the version to reflect the schema change
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Handle schema upgrades
      onOpen: (db) async {
        // Handle exception if DB or table exists
        try {
          await db.execute('SELECT * FROM users LIMIT 1');
        } catch (e) {
          await _createDB(db, 1);
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // User table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Communities table
    await db.execute('''
      CREATE TABLE communities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // User-Communities join table
    await db.execute('''
      CREATE TABLE user_communities (
        userId INTEGER NOT NULL,
        communityId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (communityId) REFERENCES communities(id) ON DELETE CASCADE,
        PRIMARY KEY (userId, communityId)
      )
    ''');

    // Habits table (without frequency column initially)
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        startDate TEXT,
        breakDates TEXT,
        frequency TEXT NOT NULL,
        notificationsEnabled INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
  CREATE TABLE reminders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    habitId INTEGER,
    userId INTEGER,
    reminderTime TEXT,
    message TEXT,
    FOREIGN KEY (habitId) REFERENCES habits(id) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
  )
''');

    // Insert predefined communities
    await insertPredefinedCommunities(db);
  }

  // Handle schema upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // In version 2, we added the 'frequency' column to the habits table
      await db.execute('''
        ALTER TABLE habits ADD COLUMN frequency TEXT;
      ''');
    }
  }

  // Method to insert predefined communities
  Future<void> insertPredefinedCommunities(Database db) async {
    List<String> communityNames = [
      'Fitness',
      'Reading',
      'Mindfulness',
      'Productivity'
    ];

    for (var name in communityNames) {
      await db.insert(
        'communities',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate entries
      );
    }
  }

  // Method to insert a user
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate emails
    );
  }

  // Method to retrieve a user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null; // User not found
  }

  // Insert reminder into the database
  Future<void> insertReminder(Reminder reminder) async {
    final db = await instance.database; // Use 'database' instead of 'db'
    await db.insert('reminders', reminder.toMap());
  }

// Query reminders for a user
  Future<List<Map<String, dynamic>>> queryReminders(int userId) async {
    final db = await instance.database; // Use 'database' instead of 'db'
    return await db
        .query('reminders', where: 'userId = ?', whereArgs: [userId]);
  }
}
