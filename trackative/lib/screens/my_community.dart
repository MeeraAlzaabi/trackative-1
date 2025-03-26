import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackactive/screens/community_chat.dart';
import 'package:trackactive/screens/create_community.dart';
import 'package:trackactive/services/firebase_func/community_func.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';

class MyCommunityScreen extends StatefulWidget {
  const MyCommunityScreen({super.key});

  @override
  State<MyCommunityScreen> createState() => _MyCommunityScreenState();
}

class _MyCommunityScreenState extends State<MyCommunityScreen> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var communityFunc = CommunityFunc();

  Future deleteCommunity(String cId) async {
    var check = await communityFunc.deleteCommunity(cId);
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Community Deleted"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Communities'),
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: themeColorChanger(
                context,
                Colors.white,
                Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCommunityScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("creatorId", isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snap.hasData) {
            return Text(
              "No Communities Created",
              style: TextStyle(
                color: themeColorChanger(
                  context,
                  Colors.white,
                  Colors.black,
                ),
              ),
            );
          }
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityChatScreen(
                            name: data["communityName"],
                            id: data["cId"],
                            creatorId: data["creatorId"],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      data['communityName'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Joins : ${data["users"].length}"),
                    trailing: ElevatedButton(
                      onPressed: () async => await deleteCommunity(data["cId"]),
                      child: const Text('Delete'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
