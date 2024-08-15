import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20.sp, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.black),
    bodySmall: TextStyle(fontSize: 14.sp, color: Colors.black),
    headlineMedium: TextStyle(
      fontSize: 32.sp,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
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
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(14.r),
    ),
    fillColor: const Color(0xffF5F9FE),
    filled: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 24.w,
      vertical: 18.h,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: const Color(0xff3461FD), width: 2.r),
      borderRadius: BorderRadius.circular(14.r),
    ),
    border: InputBorder.none,
    hintStyle: TextStyle(
      color: const Color(0xff7C8BA0),
      fontSize: 16.r,
    ),
    errorStyle: TextStyle(
      color: Colors.red,
      fontSize: 12.r,
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fillColor: WidgetStatePropertyAll(Color(0xffF5F9FE)),
    checkColor: WidgetStatePropertyAll(Colors.black),
    splashRadius: 0,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20.sp, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.white),
    bodySmall: TextStyle(fontSize: 14.sp, color: Colors.white),
    headlineMedium: TextStyle(
      fontSize: 32.sp,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: const WidgetStatePropertyAll(Color(0xff845ec2)),
      textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shadowColor: const WidgetStatePropertyAll(Color(0xff845ec2)),
      backgroundColor: const WidgetStatePropertyAll(Color(0xff845ec2)),
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
    foregroundColor: Colors.white,
    toolbarHeight: 80.h,
    toolbarTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(14.r),
    ),
    fillColor: const Color(0xffF5F9FE),
    filled: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 24.w,
      vertical: 18.h,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: const Color(0xff845ec2), width: 2.r),
      borderRadius: BorderRadius.circular(14.r),
    ),
    border: InputBorder.none,
    hintStyle: TextStyle(
      color: const Color(0xff7C8BA0),
      fontSize: 16.r,
    ),
    errorStyle: TextStyle(
      color: Colors.red,
      fontSize: 12.r,
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fillColor: WidgetStatePropertyAll(Color(0xffF5F9FE)),
    checkColor: WidgetStatePropertyAll(Color(0xff845ec2)),
    splashRadius: 0,
  ),
);
