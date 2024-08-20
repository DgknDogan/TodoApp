import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xffF5F9FE),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: const _CustomAuthButton(
          text: "Facebook",
          asset: "assets/_Facebook.png",
        ),
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class GoogleButton extends StatelessWidget {
  final Function signInWithGoogle;

  const GoogleButton({super.key, required this.signInWithGoogle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await signInWithGoogle();
          if (context.mounted) {
            if (_auth.currentUser != null) {
              context.router.push(const InitialRoute());
            }
          }
        },
        child: const _CustomAuthButton(
          text: "Google",
          asset: "assets/_Google.png",
        ),
      ),
    );
  }
}

class _CustomAuthButton extends StatelessWidget {
  final String text;
  final String asset;

  const _CustomAuthButton({required this.text, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 131.w,
        height: 24.h,
        child: Row(
          children: [
            Image.asset(asset),
            SizedBox(width: 16.w),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ],
        ),
      ),
    );
  }
}
