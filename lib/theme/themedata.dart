import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  // Primary colors
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary:
        Color(0xFF1F1F1F), // Black for primary elements (e.g., buttons, icons)
    onPrimary: Color(0xFFFFFFFF), // White for text/icons on primary color
    secondary: Color(0xFFF4B342), // Gold for accents and secondary elements
    onSecondary: Color(0xFFFFFFFF), // Black text on white background
    surface: Color(0xFFF5F5F5), // Light grey surfaces like cards or text fields
    onSurface: Color(0xFF1F1F1F), // Text on surface color
    error: Colors.redAccent, // Error colors if needed
    onError: Colors.white,
    tertiary: Color(0xFFBFA567), // A muted gold for tertiary highlights
    outline: Color(0xFFDADADA), // For border colors like input fields
    shadow: Colors.black26, // Subtle shadows under elements
  ),

  // Text styles
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F1F1F), // Bold black for prominent headings
    ),
    titleLarge: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F1F1F), // Slightly smaller titles in black
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF1F1F1F), // Regular body text
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: Color(0xFF707070), // Lighter grey for secondary text
    ),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF4B342), // Gold for labels and buttons
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFFF4B342), // White text on buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded buttons
      ),
      elevation: 5.0, // Slight shadow effect
    ),
  ),

  // Input field (TextField) theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF5F5F5), // Light grey for input field background
    hintStyle:
        const TextStyle(color: Color(0xFF707070)), // Light grey for hints
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide:
          const BorderSide(color: Color(0xFFDADADA)), // Light grey borders
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(
          color: Color(0xFFF4B342)), // Gold for focused borders
    ),
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1F1F1F), // Black for the app bar
    iconTheme: IconThemeData(color: Color(0xFFFFFFFF)), // White icons
    titleTextStyle: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0,
  ),
);
