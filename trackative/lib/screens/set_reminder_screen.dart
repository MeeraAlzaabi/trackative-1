import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackactive/models/habit.dart';
import 'package:trackactive/services/firebase_func/reminder_func.dart';
import 'package:trackactive/models/reminder.dart';
import 'package:trackactive/services/notification/notification_impl.dart';
import 'package:trackactive/services/state/home_state.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';
import 'package:uuid/uuid.dart';

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  SetReminderScreenState createState() => SetReminderScreenState();
}

class SetReminderScreenState extends State<SetReminderScreen> {
  HabitModel? _selectedHabit;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var habitId = "";
  final reminderFunc = ReminderFunc();
  var home = Get.put(HomeState());
  List<HabitModel> _habits = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _messageController = TextEditingController();

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

  // Future<void> _loadReminders() async {
  //   final reminders =
  //       await ReminderService().getRemindersForUser(widget.userId);
  //   setState(() {
  //     _reminders = reminders;
  //   });
  // }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  int generateRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Future<String> getHName(String id) async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("habits")
        .doc(id)
        .get();
    return data["name"];
  }

  Future<void> _setReminder() async {
    if (_selectedHabit != null && _selectedHabit!.id != null) {
      var rId = const Uuid().v1();
      var now = DateTime.now();
      DateTime date = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final reminder = Reminder(
        id: rId,
        habitId: _selectedHabit!.id,
        userId: uid,
        habitName: _selectedHabit!.name,
        reminderTime: Timestamp.fromDate(date),
        message: _messageController.text,
      );

      // await ReminderService().addReminder(reminder);
      await reminderFunc.createReminder(reminder);

      if (mounted) {
        await NotificationService().scheduleNotification(
          generateRandomInt(0, 99),
          "Habit Reminder",
          _messageController.text,
          reminder.reminderTime.toDate(),
        );
        await home.getRemindersLength();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder set successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a habit first.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Habit Reminder'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 16),

            // Time Picker Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.access_time),
              label: Text('Select Time: ${_selectedTime.format(context)}'),
            ),
            const SizedBox(height: 16),

            // Message Input Field
            Container(
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
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Reminder Message',
                  hintText: 'Enter your reminder message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Set Reminder Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _setReminder,
              child: const Text('Set Reminder'),
            ),
            const SizedBox(height: 24),

            // Display list of reminders
            Text(
              'Reminders for your habits:',
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
            const SizedBox(height: 8),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .collection("reminders")
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snap.hasData) {
                  return Text(
                    "No Reminders Found",
                    style: TextStyle(
                      fontSize: 16,
                      color: themeColorChanger(
                        context,
                        Colors.white,
                        Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, index) {
                      final reminder = snap.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(
                            Icons.notifications_active,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            'Habit Name: ${reminder["name"]}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Time: ${{
                              DateFormat('HH:mm').format(
                                reminder["reminderTime"].toDate(),
                              )
                            }} - ${reminder["message"]}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              await reminderFunc.deleteReminder(reminder["id"]);
                              await home.getRemindersLength();
                            },
                            child: const Text('Delete'),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
