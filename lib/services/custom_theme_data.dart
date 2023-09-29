import 'package:flutter/material.dart';

class CustomThemeData {
  static const Color primary = Color(0xFFFB7819);
  static const Color secondaryLight = Color(0xFF1482C2);
  static const Color secondaryDark = Color(0xFF004989);
  static const Color light = Color(0xFFFAFAFA);
  static const Color dark = Color(0xFF1F1D1D);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    hintColor: secondaryLight,
    cardColor: primary,
    canvasColor: light,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: dark, fontSize: 16),
      bodyMedium: TextStyle(color: dark, fontSize: 20),
      bodyLarge: TextStyle(color: dark, fontSize: 24),
      labelMedium: TextStyle(color: secondaryLight, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: light, unselectedItemColor: dark),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    hintColor: secondaryDark,
    cardColor: dark,
    canvasColor: dark,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: light, fontSize: 16),
      bodyMedium: TextStyle(color: light, fontSize: 20),
      bodyLarge: TextStyle(color: light, fontSize: 24),
      labelMedium: TextStyle(color: light, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary, unselectedItemColor: light),
  );
}
