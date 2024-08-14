import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final theme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20.sp, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.black),
    bodySmall: TextStyle(fontSize: 14.sp, color: Colors.black),
  ),
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: const WidgetStatePropertyAll(Color(0xff2A4ECA)),
      textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shadowColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
      backgroundColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      elevation: const WidgetStatePropertyAll(8),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16.sp)),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14.r),
          ),
        ),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.black,
    toolbarHeight: 80.h,
    toolbarTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
);
