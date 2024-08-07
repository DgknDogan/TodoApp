import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xffF5F9FE),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: 131.w,
          height: 24.h,
          child: Row(
            children: [
              Image.asset("assets/_Facebook.png"),
              SizedBox(width: 16.w),
              Text(
                "Facebook",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xff61677D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xffF5F9FE),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: 131.w,
          height: 24.h,
          child: Row(
            children: [
              Image.asset("assets/_Google.png"),
              SizedBox(width: 16.w),
              Text(
                "Google",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xff61677D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
