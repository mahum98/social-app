import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.purple[600]!, // AppBar and Bottom Navigation selected color
    secondary: Colors.purple[200]!, // Backgrounds for cards
    surface: Colors.grey[800]!, // Calendar background
    background: Colors.black, // General background
    onPrimary: Colors.white, // Icons and text on primary
    onSecondary: Colors.white, // Text inside cards
    onSurface: Colors.white, // Text on Calendar, Event details
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.purple[600]!,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.purple[600]!,
    unselectedItemColor: Colors.grey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[600]!,
    foregroundColor: Colors.white, // Plus icon color
  ),
);