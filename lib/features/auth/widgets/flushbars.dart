import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Flushbar<dynamic> customFlushbar(String message, Color color) {
  return Flushbar(
    backgroundColor: color,
    blockBackgroundInteraction: true,
    messageText: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    duration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 400),
    routeBlur: 2,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(30.r),
    margin: EdgeInsets.symmetric(
      horizontal: 40.w,
      vertical: 40.h,
    ),
  );
}
