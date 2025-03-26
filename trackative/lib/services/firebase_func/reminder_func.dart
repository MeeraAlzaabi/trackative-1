import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackactive/models/habit.dart';
import 'dart:developer' as d;

import 'package:trackactive/models/reminder.dart';
import 'package:trackactive/services/notification/notification_impl.dart';

class ReminderFunc {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Create Reminder
  Future<bool> createReminder(Reminder reminder) async {
    try {
      await firestore
          .collection("users")
          .doc(uid)
          .collection("reminders")
          .doc(reminder.id)
          .set(reminder.toMap());
      return true;
    } catch (e) {
      d.log(e.toString());
      return false;
    }
  }

  // Get Habits
  Future<List<HabitModel>> getHabitsList() async {
    try {
      var data = await firestore
          .collection("users")
          .doc(uid)
          .collection("habits")
          .get();
      var listof = data.docs.map((e) => HabitModel.fromMap(e)).toList();
      return listof;
    } catch (e) {
      d.log(e.toString());
      throw Exception(e.toString());
    }
  }

  // Delete Reminder
  Future<bool> deleteReminder(String rId) async {
    try {
      await firestore
          .collection("users")
          .doc(uid)
          .collection("reminders")
          .doc(rId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
