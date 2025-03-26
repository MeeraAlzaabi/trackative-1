import 'package:flutter/material.dart';
import 'package:trackactive/services/firebase_func/firebase_func.dart';
import 'package:trackactive/widgets/theme_color_changer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final firebaseFunc = FirebaseFunc();

  // Email regex pattern
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  // Validate the email format
  bool _isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  void _register() async {
    // Check if the email is valid
    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: Colors.red, // Red color for alert
        ),
      );
      return; // Exit if email is invalid
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      // Show error message if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit if passwords don't match
    }

    if (_passwordController.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords length must be 8'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least one uppercase letter.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Password must contain at least one special character..'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var isCreated = await firebaseFunc.createUser(
      _emailController.text,
      _passwordController.text,
    );

    if (isCreated.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCreated),
          backgroundColor: Colors.red, // Red color for alert
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                        'Create Your Account',
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        style: TextStyle(
                          color: themeColorChanger(
                            context,
                            Colors.white,
                            Colors.black,
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Buttons for Login and Terms
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Already have an account? Login'),
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
