import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String? id;
  final String habitId;
  final String habitName;
  final String userId;
  final Timestamp reminderTime;
  final String message;

  Reminder({
    this.id,
    required this.habitId,
    required this.userId,
    required this.habitName,
    required this.reminderTime,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'userId': userId,
      'name': habitName,
      'reminderTime': reminderTime,
      'message': message,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      habitName: map["name"],
      habitId: map['habitId'],
      userId: map['userId'],
      reminderTime: Timestamp.now(),
      message: map['message'],
    );
  }
}
