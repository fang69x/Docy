import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;

  const CustomElevatedButton(
      {super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 47.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label:
            Text(label, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.deepPurple.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
      ),
    );
  }
}
