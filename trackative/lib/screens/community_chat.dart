import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trackactive/services/firebase_func/chat_func.dart';
import 'package:trackactive/services/firebase_func/community_func.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class CommunityChatScreen extends StatefulWidget {
  final String name;
  final String id;
  final String creatorId;

  const CommunityChatScreen({
    super.key,
    required this.name,
    required this.id,
    required this.creatorId,
  });

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var message = TextEditingController();
  var chatFunc = ChatFunc();
  var community = CommunityFunc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
          widget.creatorId == uid
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: themeColorChanger(
                      context,
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    await community.removeCommunity(widget.id);
                    Navigator.pop(context);
                  },
                ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .doc(widget.id)
            .collection("chat")
            .orderBy("sendingDate")
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: data["senderId"] == uid
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: data["senderId"] == uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 12),
                          //   child: Text(
                          //     data["senderEmail"].split("@")[0],
                          //     style: TextStyle(
                          //       color: themeColorChanger(
                          //         context,
                          //         Colors.white,
                          //         Colors.black,
                          //       ),
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          BubbleSpecialOne(
                            isSender: data["senderId"] == uid ? true : false,
                            text: data["message"],
                            color: Colors.blue,
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              timeago.format(data["sendingDate"].toDate()),
                              style: TextStyle(
                                fontSize: 10,
                                color: themeColorChanger(
                                  context,
                                  Colors.white,
                                  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: message,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Enter your message',
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await chatFunc.sendMessage(message.text, widget.id);
                message.clear();
              },
              child: const CircleAvatar(
                radius: 20,
                child: Center(
                  child: Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
