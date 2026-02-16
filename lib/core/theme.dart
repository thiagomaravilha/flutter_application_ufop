import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF1976D2), // Azul
        onPrimary: Colors.white,
        secondary: Color(0xFFFF9800), // Laranja
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFFE3F2FD),
        selectedColor: Color(0xFFFFE0B2),
        checkmarkColor: Colors.white,
      ),
    );
  }
}