import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final String? senderId;
  final Timestamp? sendingDate;
  final String? message;
  final String? senderEmail;

  ChatModel({
    this.id,
    this.senderId,
    this.sendingDate,
    this.message,
    this.senderEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "senderId": senderId,
      "sendingDate": sendingDate,
      "message": message,
      "senderEmail": senderEmail,
    };
  }
}
