import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackactive/models/habit.dart';
import 'package:trackactive/services/firebase_func/habit_firebase.dart';
import 'package:trackactive/services/state/home_state.dart';
import 'package:trackactive/services/state/progress_state.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';
import 'package:uuid/uuid.dart';

class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({super.key});

  @override
  HabitCreationScreenState createState() => HabitCreationScreenState();
}

class HabitCreationScreenState extends State<HabitCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final habitFirebase = HabitFirebase();
  DateTime? _startDate;
  var progress = Get.put(ProgressState());
  var home = Get.put(HomeState());
  var uid = FirebaseAuth.instance.currentUser!.uid;
  String _frequency = 'Daily';
  bool _notificationsEnabled = false;

  // Function to pick a start date
  Future<void> _pickStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  // Function to create a habit and refresh the habit list
  void _createHabit() async {
    // if (widget.userId == 0) {
    //   return;
    // }
    var hId = const Uuid().v1();

    final habitModel = HabitModel(
      id: hId,
      userId: uid,
      name: _nameController.text,
      startDate: Timestamp.fromDate(_startDate!),
      breakDates: "",
      notificationsEnabled: _notificationsEnabled ? 1 : 0,
      frequency: _frequency,
      isCompleted: false,
    );

    await habitFirebase.createHabit(habitModel);
    //  await HabitService().addHabit(habit);

    // Refresh the habit list after creating a new habit
    // await _loadHabits();

    if (mounted) {
      // Show success message after confirming the widget is still mounted
      await home.getHabitsLength();
      await progress.percentage();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit Created Successfully!')),
      );
    }
  }

  // // Function to load the user's habits from the database
  // Future<void> _loadHabits() async {
  //   final habits = await HabitService().getHabitsByUserId(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _habits = habits;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Load the initial list of habits when the screen is loaded
  //   _loadHabits();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Habit'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: themeColorChanger(
                    context,
                    Colors.black,
                    Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Habit name input
                    TextField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeColorChanger(
                          context,
                          Colors.white,
                          Colors.black,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Habit Name',
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
                    const SizedBox(height: 16),

                    // Start date selection with improved display
                    GestureDetector(
                      onTap: _pickStartDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: themeColorChanger(
                                context,
                                Colors.white,
                                Colors.grey,
                              ),
                            ),
                            labelText: _startDate == null
                                ? 'Start Date'
                                : DateFormat('MMM d, yyyy').format(_startDate!),
                            border: const OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: themeColorChanger(
                                context,
                                Colors.white,
                                Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Frequency dropdown
                    DropdownButtonFormField<String>(
                      value: _frequency,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeColorChanger(
                          context,
                          Colors.white,
                          Colors.black,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _frequency = newValue!;
                        });
                      },
                      items: <String>['Daily', 'Weekly', 'Monthly']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Frequency',
                        labelStyle: TextStyle(
                          color: themeColorChanger(
                            context,
                            Colors.white,
                            Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notification switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable Notifications',
                          style: TextStyle(
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.black,
                            ),
                          ),
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Create habit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createHabit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create Habit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Created habits list
              Text(
                'Created Habits:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: themeColorChanger(
                    context,
                    Colors.white,
                    Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Habit list display
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("habits")
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (!snap.hasData) {
                    return Text(
                      "No Habits Created",
                      style: TextStyle(
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
                        final habit = snap.data!.docs[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(habit["name"]),
                            subtitle: Text(
                              'Frequency: ${habit["frequency"]}, Start Date: ${DateFormat('MMM d, yyyy').format(
                                habit["startDate"].toDate(),
                              )}',
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
      ),
    );
  }
}
