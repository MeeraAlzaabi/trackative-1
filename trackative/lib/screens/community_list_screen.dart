import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackactive/screens/community_chat.dart';
import 'package:trackactive/services/firebase_func/community_func.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({super.key});

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var communityFunc = CommunityFunc();

  Future joinCommunity(String cId) async {
    await communityFunc.joinCommunity(cId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You join the community $cId"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Communities'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: themeColorChanger(
              context,
              Colors.white,
              Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("communities")
                  .where("creatorId", isNotEqualTo: uid)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snap.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              data['communityName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: data["users"].contains(uid)
                                ? const Icon(Icons.check, color: Colors.green)
                                : ElevatedButton(
                                    onPressed: () async =>
                                        await joinCommunity(data["cId"]),
                                    child: const Text('Join'),
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "You Joined Communities :",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeColorChanger(
                  context,
                  Colors.white,
                  Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("communities")
                  .where("creatorId", isNotEqualTo: uid)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var data = snap.data!.docs.where((e) {
                    var d = e["users"].contains(uid);
                    return d;
                  }).toList();
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var coum = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              coum['communityName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommunityChatScreen(
                                      name: coum["communityName"],
                                      id: coum["cId"],
                                      creatorId: coum["creatorId"],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Message'),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
