import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  final SharedPreferences prefs;

  ThemeProvider(this.prefs) {
    // Load the user's preferred theme from SharedPreferences or use the default theme.
    _themeData = (prefs.getBool('isDarkMode') ?? false) ? _darkTheme : _lightTheme;
  }

  ThemeData get themeData => _themeData;

  final ThemeData _lightTheme = ThemeData.light();
  final ThemeData _darkTheme = ThemeData.dark();

  // Toggle between light and dark themes.
  void toggleTheme() {
    _themeData = (_themeData == _lightTheme) ? _darkTheme : _lightTheme;
    notifyListeners();
    prefs.setBool('isDarkMode', _themeData == _darkTheme);
  }
}
