import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackactive/models/habit.dart';
import 'package:trackactive/services/firebase_func/habit_firebase.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';

class HabitEditScreen extends StatefulWidget {
  final HabitModel habitModel;
  const HabitEditScreen({
    super.key,
    required this.habitModel,
  });

  @override
  HabitEditScreenState createState() => HabitEditScreenState();
}

class HabitEditScreenState extends State<HabitEditScreen> {
  var _nameController = TextEditingController();
  var habitFirebase = HabitFirebase();
  var _frequency = 'Daily';
  DateTime? _startDate;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habitModel.name);
    _frequency = widget.habitModel.frequency;
    // ignore: unnecessary_null_comparison
    _startDate = widget.habitModel.startDate.toDate();

    _notificationsEnabled = widget.habitModel.notificationsEnabled == 1;
  }

  Future<void> _pickStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  void _saveChanges() async {
    final updatedHabit = HabitModel(
      id: widget.habitModel.id,
      userId: widget.habitModel.userId,
      name: _nameController.text,
      startDate: Timestamp.fromDate(_startDate!),
      breakDates: widget.habitModel.breakDates,
      notificationsEnabled: _notificationsEnabled ? 1 : 0,
      frequency: _frequency,
      isCompleted: false,
    );

    // await HabitService().updateHabit(updatedHabit);

    await habitFirebase.editHabit(updatedHabit);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
                Text(
                  'Start Date: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: themeColorChanger(
                      context,
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                ),
                Text(
                  _startDate == null
                      ? 'Not Selected'
                      : _startDate!.toLocal().toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    color: themeColorChanger(
                      context,
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: themeColorChanger(
                      context,
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                  onPressed: _pickStartDate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
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
              style: TextStyle(
                fontSize: 16,
                color: themeColorChanger(
                  context,
                  Colors.white,
                  Colors.black,
                ),
              ),
              decoration: InputDecoration(
                labelText: 'Frequency',
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
            Row(
              children: [
                Text(
                  'Enable Notifications',
                  style: TextStyle(
                    fontSize: 16,
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
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
