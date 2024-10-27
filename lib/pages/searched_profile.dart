import 'package:flutter/material.dart';

class SearchedProfile extends StatelessWidget {
  final String userId;

  const SearchedProfile({Key? key, required this.userId}) : super(key: key);
  @override

  @override
  Widget build(BuildContext context) {
  // Here you would typically fetch user data using the userId
  return Scaffold(
  appBar: AppBar(
  title: const Text("User Profile"),
  ),
  body: Center(
  child: Text(
  "Profile Page for User ID: $userId",
  style: const TextStyle(fontSize: 24),
  ),
  ),
  );
  }
  }

