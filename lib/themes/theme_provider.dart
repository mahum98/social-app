import 'package:flutter/material.dart';
import 'package:mad/themes/dark_mode.dart';
import 'package:mad/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode; // Default theme

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners to update UI
  }


  void toggleTheme() {
    // Toggle between light and dark mode
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
