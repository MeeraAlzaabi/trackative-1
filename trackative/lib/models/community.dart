import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String? cId;
  final String? communityName;
  final String? creatorId;
  final Timestamp? createdDate;
  final List<String>? users;

  CommunityModel({
    this.cId,
    this.communityName,
    this.creatorId,
    this.createdDate,
    this.users,
  });

  Map<String, dynamic> toMap() {
    return {
      'cId': cId,
      'communityName': communityName,
      'creatorId': creatorId,
      'createdDate': createdDate,
      'users': users,
    };
  }
}
