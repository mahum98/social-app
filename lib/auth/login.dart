import 'package:flutter/material.dart';
import 'package:mad/auth/fields.dart';
import 'package:mad/auth/signup_page.dart';
import 'package:mad/services/auth_service.dart';
import 'package:mad/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final String loginTop = "assets/login_top.png";
  final String bottomImage = "assets/cloud.png";

  void _login() async {
    await _authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      context: context,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Images
          Positioned(
            top: 0,
            left: 0,
            child: Opacity(
              opacity: 0.7, // Set the desired opacity value
              child: Image.asset(
                loginTop, // Ensure this variable is defined
                width: 300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                // Adjusted height to move Login text higher
                Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),// Increased font size for visibility
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),// Increased font size for visibility
                  ),
                ),
                SizedBox(height: 80),
                // Spacing between title and input fields
                EmailField(emailController: _emailController),
                SizedBox(height: 20),
                PasswordField(passwordController: _passwordController),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _login, // Ensure this function is defined
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 164.0), // Adjust padding
                   // minimumSize: Size(150, 50), // Set minimum size (width, height)
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignUpPage(), // Ensure SignUpPage is defined
                      ),
                    );
                  },
                  child: Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4, // Set the desired opacity value
              child: Image.asset(
                bottomImage, // Ensure this variable is defined
                width: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}