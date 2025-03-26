import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackactive/models/chat.dart';
import 'dart:developer' as d;

import 'package:uuid/uuid.dart';

class ChatFunc {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;

  // Start Chat
  Future<void> sendMessage(String message, String cId) async {
    try {
      var mId = const Uuid().v1();
      var chat = ChatModel(
        id: mId,
        senderId: uid,
        senderEmail: email,
        sendingDate: Timestamp.now(),
        message: message,
      ).toMap();
      await firestore
          .collection("communities")
          .doc(cId)
          .collection("chat")
          .doc(mId)
          .set(chat);
    } catch (e) {
      d.log(e.toString());
    }
  }
}
