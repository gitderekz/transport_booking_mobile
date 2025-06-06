// // lib/config/theme.dart
// import 'package:flutter/material.dart';
//
// class AppTheme {
//   static final lightTheme = ThemeData(
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFF6A3CBC),
//       secondary: Color(0xFF461B93),
//       surface: Colors.white,
//       background: Color(0xFFF5F6FA),
//       error: Color(0xFFD63031),
//     ),
//     scaffoldBackgroundColor: const Color(0xFFF5F6FA),
//     cardTheme: CardTheme(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: Colors.white,
//     ),
//     appBarTheme: const AppBarTheme(
//       elevation: 0,
//       centerTitle: true,
//       backgroundColor: Colors.transparent,
//       iconTheme: IconThemeData(color: Colors.black),
//     ),
//     bottomAppBarTheme: const BottomAppBarTheme(
//       color: Colors.white,
//       elevation: 10,
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: Color(0xFF6A3CBC),
//     ),
//   );
//
//   static final darkTheme = ThemeData(
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF6A3CBC),
//       secondary: Color(0xFF461B93),
//       surface: Color(0xFF1E1E1E),
//       background: Color(0xFF121212),
//       error: Color(0xFFD63031),
//     ),
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     cardTheme: CardTheme(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: const Color(0xFF1E1E1E),
//     ),
//     appBarTheme: const AppBarTheme(
//       elevation: 0,
//       centerTitle: true,
//       backgroundColor: Colors.transparent,
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     bottomAppBarTheme: const BottomAppBarTheme(
//       color: Color(0xFF1E1E1E),
//       elevation: 10,
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: Color(0xFF6A3CBC),
//     ),
//   );
// }
// // *******************************



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