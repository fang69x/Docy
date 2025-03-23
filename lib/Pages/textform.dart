import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final InputDecoration? decoration;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 20.w,
      ),
      hintStyle: TextStyle(
        color: Colors.white54,
        fontSize: 14.sp,
      ),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
      ),
      decoration: (decoration ?? const InputDecoration()).copyWith(
        // Apply default decoration properties
        hintText: defaultDecoration.hintText,
        filled: defaultDecoration.filled,
        fillColor: defaultDecoration.fillColor,
        border: defaultDecoration.border,
        focusedBorder: defaultDecoration.focusedBorder,
        contentPadding: defaultDecoration.contentPadding,
        hintStyle: defaultDecoration.hintStyle,
        // Add prefix icon with custom styling
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(left: 16.w, right: 12.w),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.white70,
                    size: 20.w,
                  ),
                  child: prefixIcon!,
                ),
              )
            : null,
      ),
    );
  }
}
