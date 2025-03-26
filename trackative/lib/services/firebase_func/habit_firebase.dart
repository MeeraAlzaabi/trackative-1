import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackactive/models/habit.dart';
import 'dart:developer' as d;

class HabitFirebase {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  // Create Habit
  Future<bool> createHabit(HabitModel habitModel) async {
    try {
      await firestore
          .collection("users")
          .doc(habitModel.userId)
          .collection("habits")
          .doc(habitModel.id)
          .set(habitModel.toMap());
      return true;
    } catch (e) {
      d.log(e.toString());
      return false;
    }
  }

  // Edit Habit
  Future<void> editHabit(HabitModel habit) async {
    try {
      await firestore
          .collection("users")
          .doc(uid)
          .collection("habits")
          .doc(habit.id)
          .update(habit.toMap());
    } catch (e) {
      d.log(e.toString());
    }
  }

  // Get Habit
  Future<HabitModel> getHabit(String hId) async {
    try {
      var habitData = await firestore
          .collection("users")
          .doc(uid)
          .collection("habits")
          .doc(hId)
          .get();
      return HabitModel(
        id: habitData["id"],
        userId: habitData["userId"],
        name: habitData["name"],
        startDate: habitData["startDate"],
        breakDates: habitData["breakDates"],
        notificationsEnabled: habitData["notificationsEnabled"],
        frequency: habitData["frequency"],
        isCompleted: false,
      );
    } catch (e) {
      d.log(e.toString());
      throw Exception(e.toString());
    }
  }
}
