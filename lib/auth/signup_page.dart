import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:mad/auth/fields.dart';
import 'package:mad/auth/signup_page.dart';
import 'package:mad/pages/homepage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  final String signinTop = "assets/signin_top.png";
  final String bottomImage = "assets/cloud.png";

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "All fields are required.";
      });
      return;
    }

    try {
      // Create a new user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user ID from FirebaseAuth
      String userId = userCredential.user!.uid;

      // Save the user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'profilePicture': "assets/avatar.jpg", // Default profile picture path
        'createdAt': Timestamp.now(),
      });

      // Navigate to the HomePage after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        errorMessage = "An unexpected error occurred. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Images
          Positioned(
            top: 0,
            left: 0,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                signinTop,
                width: 500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    "Create New Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                UsernameField(usernameController: _usernameController),
                SizedBox(height: 20),
                EmailField(emailController: _emailController),
                SizedBox(height: 20),
                PasswordField(passwordController: _passwordController),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text("Sign Up"),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                bottomImage, // Update with actual asset path
                width: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
