// lib/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent[400], // A vibrant accent for a dark theme
    scaffoldBackgroundColor: const Color(0xFF121212), // Very dark grey, almost black
    cardColor: const Color(0xFF1E1E1E), // Slightly lighter dark grey for cards/dialogs
    hintColor: Colors.tealAccent[200], // For hints and secondary text
    dividerColor: Colors.grey[800],

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1F1F1F), // Darker app bar
      elevation: 0, // Flat app bar
      iconTheme: IconThemeData(color: Colors.tealAccent[400]),
      titleTextStyle: TextStyle(
        color: Colors.tealAccent[400],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w600), // For screen titles
      bodyLarge: TextStyle(color: Colors.grey[300], fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[400], fontSize: 14), // Standard text
      labelLarge: TextStyle(color: Colors.tealAccent[400], fontWeight: FontWeight.bold, fontSize: 16), // For button text
      bodySmall: TextStyle(color: Colors.grey[500]), // For captions or less important text
    ),

    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      buttonColor: Colors.tealAccent[400], // Button background
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent[400], // Background color
        foregroundColor: Colors.black, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A), // Darker input field background
      hintStyle: TextStyle(color: Colors.grey[600]),
      labelStyle: TextStyle(color: Colors.tealAccent[200]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // No border by default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[700]!), // Subtle border when enabled
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.tealAccent[400]!, width: 2.0), // Accent border when focused
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.redAccent[200]!, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.redAccent[400]!, width: 2.0),
      ),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titleTextStyle: TextStyle(color: Colors.tealAccent[400], fontSize: 18, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.grey[300], fontSize: 16),
    ),

    // Color scheme for more granular control if needed
    colorScheme: ColorScheme.dark(
      primary: Colors.tealAccent[400]!,
      secondary: Colors.cyanAccent[400]!,
      surface: const Color(0xFF121212),
      background: const Color(0xFF121212),
      error: Colors.redAccent[200]!,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
  );
}
