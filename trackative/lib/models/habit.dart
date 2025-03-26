import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final Timestamp startDate;
  final String breakDates;
  final int notificationsEnabled;
  final String frequency;
  final bool isCompleted;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.startDate,
    required this.breakDates,
    required this.notificationsEnabled,
    required this.frequency,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'startDate': startDate,
      'breakDates': breakDates,
      'notificationsEnabled': notificationsEnabled,
      'frequency': frequency,
      'isCompleted': isCompleted,
    };
  }

  static HabitModel fromMap(DocumentSnapshot map) {
    return HabitModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      startDate: map['startDate'],
      breakDates: map['breakDates'],
      notificationsEnabled: map['notificationsEnabled'],
      frequency: map['frequency'],
      isCompleted: map["isCompleted"],
    );
  }
}
