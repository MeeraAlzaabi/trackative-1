import 'package:flutter/material.dart';
import 'package:trackactive/services/firebase_func/community_func.dart';

import '../widgets/theme_color_changer.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  var name = TextEditingController();
  var communityFunc = CommunityFunc();

  Future createCommunity() async {
    if (name.text.isNotEmpty) {
      await communityFunc.createCommunity(name.text);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Community Created"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter name"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: name,
                style: TextStyle(
                  fontSize: 16,
                  color: themeColorChanger(
                    context,
                    Colors.white,
                    Colors.black,
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'Community Name',
                  labelStyle: TextStyle(
                    color: themeColorChanger(
                      context,
                      Colors.white,
                      Colors.grey,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async => await createCommunity(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Community',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
