import 'package:flutter/material.dart';

class ThemeManager {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  ThemeData currentTheme;

  ThemeManager()
      : lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    // Add more theme properties
  ),
        darkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          // Add more theme properties
        ),
        currentTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          // Set the initial theme
        );

  void toggleTheme() {
    currentTheme = (currentTheme == lightTheme) ? darkTheme : lightTheme;
  }
}

