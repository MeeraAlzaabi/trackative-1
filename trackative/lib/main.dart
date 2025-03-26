import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackactive/firebase_options.dart';
import 'package:trackactive/screens/forgot_password_screen.dart';
import 'package:trackactive/screens/login_screen.dart';
import 'package:trackactive/screens/my_community.dart';
import 'package:trackactive/screens/signup_screen.dart';
import 'package:trackactive/screens/home_screen.dart';
import 'package:trackactive/screens/habit_list_screen.dart';
import 'package:trackactive/services/firebase_func/firebase_func.dart';
import 'package:trackactive/services/notification/notification_impl.dart';
import 'package:trackactive/services/state/theme_state.dart';
import 'package:trackactive/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseFunc = FirebaseFunc();
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  var theme = Get.put(ThemeState());

  theme.getTheme();

  // Fetch reminders and schedule notifications
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;

  // Initialize SharedPreferences to check login status
  // final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = firebaseFunc.isLogged();
  // final userId = prefs.getInt('userId');

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrackActive',
      initialRoute: isLoggedIn ? '/home' : '/login',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      routes: {
        '/': (context) => const LoginScreen(),
        '/sign_up': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/my_community': (context) => const MyCommunityScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          if (!isLoggedIn) {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        }

        if (settings.name == '/habit_list') {
          final userId = settings.arguments as int?;
          if (userId == null) {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const HabitListScreen(),
          );
        }

        return null;
      },
    );
  }
}
