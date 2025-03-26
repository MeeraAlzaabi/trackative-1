import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trackactive/screens/community_list_screen.dart';
import 'package:trackactive/screens/habit_list_screen.dart';
import 'package:trackactive/screens/habit_creation_screen.dart';
import 'package:trackactive/screens/make_your_progress.dart';
import 'package:trackactive/screens/my_community.dart';
import 'package:trackactive/screens/set_reminder_screen.dart';
import 'package:trackactive/services/firebase_func/firebase_func.dart';
import 'package:trackactive/services/state/home_state.dart';
import 'package:trackactive/services/state/progress_state.dart';
import 'package:trackactive/services/state/theme_state.dart';

import '../widgets/theme_color_changer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseFunc = FirebaseFunc();
  var theme = Get.put(ThemeState());
  var email = FirebaseAuth.instance.currentUser!.email;
  var home = Get.put(HomeState());
  var progress = Get.put(ProgressState());

  @override
  void initState() {
    theme.getTheme();
    home.getHabitsLength();
    home.getRemindersLength();
    progress.percentage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => theme.changeTheme(),
              icon: theme.themeChange.value
                  ? Icon(
                      Icons.nightlight_outlined,
                      color: themeColorChanger(
                        context,
                        Colors.white,
                        Colors.black,
                      ),
                    )
                  : Icon(
                      Icons.wb_sunny_outlined,
                      color: themeColorChanger(
                        context,
                        Colors.white,
                        Colors.black,
                      ),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: themeColorChanger(
                context,
                Colors.white,
                Colors.black,
              ),
            ),
            onPressed: () async {
              // Handle log out here
              var logout = await firebaseFunc.logout();
              if (logout) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome, User $email!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 5,
                      color: themeColorChanger(
                        context,
                        Colors.black,
                        Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Obx(
                              () => Text(
                                home.totalHabits.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: themeColorChanger(
                                    context,
                                    Colors.white,
                                    Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Your Total Habits",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: themeColorChanger(
                                  context,
                                  Colors.white,
                                  Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      color: themeColorChanger(
                        context,
                        Colors.black,
                        Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Obx(
                              () => Text(
                                home.totalReminders.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: themeColorChanger(
                                    context,
                                    Colors.white,
                                    Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Active Reminders",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: themeColorChanger(
                                  context,
                                  Colors.white,
                                  Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                color: themeColorChanger(
                  context,
                  Colors.black,
                  Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Obx(
                          () => CircularPercentIndicator(
                            radius: 34,
                            percent: progress.progress.value,
                            progressColor: Colors.blue,
                            center: Obx(
                              () => Text(
                                "${progress.percent.value}%",
                                style: TextStyle(
                                  color: themeColorChanger(
                                    context,
                                    Colors.white,
                                    Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Progress",
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                Icons.rocket_launch_outlined,
                'Mark Your Progress',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MakeYourProgressScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                Icons.list,
                'View Habit List',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HabitListScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              _buildActionCard(
                context,
                Icons.add_circle_outline,
                'Add New Habit',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HabitCreationScreen(),
                    ),
                  );
                },
              ),
              // const SizedBox(height: 16),
              // _buildActionCard(
              //   context,
              //   Icons.show_chart,
              //   'Visualize Habit Progress',
              //   () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             HabitVisualizationScreen(userId: userId),
              //       ),
              //     );
              //   },
              // ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                Icons.group,
                'Join Community',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                Icons.group,
                'My Community',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCommunityScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                Icons.notifications,
                'Set Habit Reminders',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetReminderScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the action cards with icons and text
  Widget _buildActionCard(
      BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return Card(
      elevation: 5,
      color: themeColorChanger(
        context,
        Colors.black,
        Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
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
              ),
              const Icon(Icons.arrow_forward, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
