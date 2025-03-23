import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final ButtonStyle? style;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color.fromARGB(255, 137, 74, 226),
      elevation: 4,
      minimumSize: Size(double.infinity, 52.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide.none,
      ),
    );

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(label),
      style: defaultStyle.merge(style),
    );
  }
}
