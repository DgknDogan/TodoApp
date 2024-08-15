import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderText extends StatelessWidget {
  final String title;
  final String text;

  const HeaderText({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: const Color(0xff2A4ECA),
              ),
        ),
        SizedBox(height: 16.h),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xff61677D),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
