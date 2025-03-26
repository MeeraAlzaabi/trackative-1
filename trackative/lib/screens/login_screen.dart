import 'package:flutter/material.dart';
import 'package:trackactive/services/firebase_func/firebase_func.dart';
import 'dart:developer' as d;

import 'package:trackactive/widgets/theme_color_changer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final firebaseFunc = FirebaseFunc();

  // Email regex pattern
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  // Validate the email format
  bool _isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Check if email is valid
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final loginSuccess = await firebaseFunc.loginUser(email, password);
    d.log(loginSuccess);

    if (loginSuccess.isEmpty) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loginSuccess),
          backgroundColor: Colors.red, // Red color for alert
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(
                          color: themeColorChanger(
                            context,
                            Colors.white,
                            Colors.black,
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.grey,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: themeColorChanger(
                            context,
                            Colors.white,
                            Colors.black,
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.grey,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: themeColorChanger(
                              context,
                              Colors.white,
                              Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Buttons for Sign Up and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: const Text('Sign Up'),
                          ),
                          Text(
                            ' | ',
                            style: TextStyle(
                              color: themeColorChanger(
                                context,
                                Colors.white,
                                Colors.black,
                              ),
                            ),
                          ), // Divider between the buttons
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot_password');
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
