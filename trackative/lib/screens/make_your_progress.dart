import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackactive/models/habit.dart';
import 'package:trackactive/services/firebase_func/reminder_func.dart';
import 'package:trackactive/services/state/progress_state.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';

import '../services/state/home_state.dart';

class MakeYourProgressScreen extends StatefulWidget {
  const MakeYourProgressScreen({super.key});

  @override
  State<MakeYourProgressScreen> createState() => _MakeYourProgressScreenState();
}

class _MakeYourProgressScreenState extends State<MakeYourProgressScreen> {
  HabitModel? _selectedHabit;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var habitId = "";
  final reminderFunc = ReminderFunc();
  var home = Get.put(HomeState());
  var progress = Get.put(ProgressState());
  List<HabitModel> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
    // _loadReminders();
  }

  Future<void> _loadHabits() async {
    final habits = await reminderFunc.getHabitsList();
    setState(() {
      _habits = habits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Your Progress'),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit Selection Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<HabitModel>(
                  value: _selectedHabit,
                  hint: const Text('Select Habit'),
                  onChanged: (HabitModel? newHabit) {
                    setState(() {
                      _selectedHabit = newHabit;
                    });
                  },
                  isExpanded: true,
                  items: _habits.map((habit) {
                    return DropdownMenuItem<HabitModel>(
                      value: habit,
                      child: Text(habit.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            _selectedHabit != null
                ? _selectedHabit!.isCompleted
                    ? Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'You completed this habit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeColorChanger(
                                context,
                                Colors.white,
                                Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Are you complete this habit ?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeColorChanger(
                                  context,
                                  Colors.white,
                                  Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .collection("habits")
                                        .doc(_selectedHabit!.id)
                                        .update({
                                      "isCompleted": true,
                                    });
                                    progress.percentage();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .collection("habits")
                                        .doc(_selectedHabit!.id)
                                        .update({
                                      "isCompleted": false,
                                    });
                                    progress.percentage();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                : Container(),
          ],
        ),
      ),
    );
  }
}
