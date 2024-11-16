import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    primaryColor: const Color(0xFFF4B342),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 240, 194, 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF4B342),
        textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        color: Colors.black54,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey.shade600,
      ),
    ),
  );

  static var backgroundGradient;

  // Add dark theme or other themes as needed
}
