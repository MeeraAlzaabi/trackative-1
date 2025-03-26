import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer' as d;

class HomeState extends GetxController {
  RxInt totalHabits = 0.obs;
  RxInt totalReminders = 0.obs;

  final firebase = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Get Habits Length
  Future getHabitsLength() async {
    try {
      var habits = await firebase
          .collection("users")
          .doc(uid)
          .collection("habits")
          .get();
      totalHabits.value = habits.docs.length;
      d.log(totalHabits.value.toString());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  // Get Reminders Length
  Future getRemindersLength() async {
    try {
      var reminders = await firebase
          .collection("users")
          .doc(uid)
          .collection("reminders")
          .get();
      totalReminders.value = reminders.docs.length;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
