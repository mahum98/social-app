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
                loginTop,
                width: 300, // Dynamic width
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height:
                                constraints.maxHeight * 0.09), // Adjust height
                        Center(
                          child: Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                constraints.maxHeight * 0.07), // Adjust height
                        EmailField(emailController: _emailController),
                        SizedBox(height: 20),
                        PasswordField(passwordController: _passwordController),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _login, // Ensure this function is defined
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0), // Adjust padding
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.8,
                                50), // Dynamic width
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
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
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                bottomImage,
                width: MediaQuery.of(context).size.width * 0.6, // Dynamic width
              ),
            ),
          ),
        ],
      ),
    );
  }
}
