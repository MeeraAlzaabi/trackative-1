import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProgressState extends GetxController {
  RxInt percent = 0.obs;
  RxDouble progress = 0.0.obs;

  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future percentage() async {
    try {
      var yeshabit = await firestore
          .collection("users")
          .doc(uid)
          .collection("habits")
          .get();

      var yesHabitLength = yeshabit.docs.where((e) {
        return e['isCompleted'] == true;
      }).length;
      var noHabitLength = yeshabit.docs.where((e) {
        return e['isCompleted'] == false;
      }).length;
      if (yesHabitLength == 0) {
        percent.value = 0;
      } else {
        percent.value =
            ((yesHabitLength / (yesHabitLength + noHabitLength)) * 100).floor();
      }
      progress.value = yesHabitLength / (yesHabitLength + noHabitLength);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
