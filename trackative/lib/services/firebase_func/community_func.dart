import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackactive/models/community.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as d;

class CommunityFunc {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Create Community
  Future createCommunity(String name) async {
    var cId = const Uuid().v1();
    try {
      if (name.isNotEmpty) {
        var model = CommunityModel(
          cId: cId,
          communityName: name,
          creatorId: uid,
          createdDate: Timestamp.now(),
          users: [],
        ).toMap();
        await firestore.collection("communities").doc(cId).set(model);
      }
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  // Delete Community
  Future<bool> deleteCommunity(String cId) async {
    try {
      await firestore.collection("communities").doc(cId).delete();
      return true;
    } catch (e) {
      d.log(e.toString());
      return false;
    }
  }

  // Join Community
  Future<void> joinCommunity(String cId) async {
    try {
      await firestore.collection("communities").doc(cId).update({
        "users": FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      d.log(e.toString());
    }
  }

  // Remove Community
  Future<void> removeCommunity(String cId) async {
    try {
      await firestore.collection("communities").doc(cId).update({
        "users": FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      d.log(e.toString());
    }
  }
}
