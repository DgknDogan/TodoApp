import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonFormDivider extends StatelessWidget {
  const ButtonFormDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color(0xffE0E5EC),
            thickness: 2.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Divider(
            color: const Color(0xffE0E5EC),
            thickness: 2.h,
          ),
        ),
      ],
    );
  }
}
