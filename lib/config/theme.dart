import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF461B93),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF461B93),
      secondary: Color(0xFF6A3CBC),
      tertiary: Color(0xFF8253D7),
      surface: Colors.white,
      background: Color(0xFFf5f6fa),
    ),
    scaffoldBackgroundColor: const Color(0xFFf5f6fa),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF2d3436)),
      displayMedium: TextStyle(color: Color(0xFF2d3436)),
      bodyLarge: TextStyle(color: Color(0xFF2d3436)),
      bodyMedium: TextStyle(color: Color(0xFF636e72)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF461B93),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF461B93),
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFFD4ADFC),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF6A3CBC),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6A3CBC),
      secondary: Color(0xFF8253D7),
      tertiary: Color(0xFFD4ADFC),
      surface: Color(0xFF2d2d2d),
      background: Color(0xFF1e1e1e),
    ),
    scaffoldBackgroundColor: const Color(0xFF1e1e1e),
    cardColor: const Color(0xFF2d2d2d),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFb2bec3)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1e1e1e),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1e1e1e),
      selectedItemColor: Color(0xFFD4ADFC),
      unselectedItemColor: Color(0xFF7f8c8d),
    ),
  );
}