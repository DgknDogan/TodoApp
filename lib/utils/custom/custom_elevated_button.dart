import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final int height;
  final double width;
  final VoidCallback onPressed;
  final String text;
  const CustomElevatedButton({
    super.key,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
