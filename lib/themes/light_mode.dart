import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.purple[300]!, // AppBar and Bottom Navigation selected color
    secondary: Colors.purple[100]!, // Backgrounds for cards
    surface: Colors.deepPurple, // Calendar background
    background: Colors.white, // General background
    onPrimary: Colors.white, // Icons and text on primary
    onSecondary: Colors.black87, // Text inside cards
    onSurface: Colors.black, // Text on Calendar, Event details
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.purple[300]!,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.purple[300]!,
    unselectedItemColor: Colors.grey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[300]!,
    foregroundColor: Colors.white, // Plus icon color
  ),
);