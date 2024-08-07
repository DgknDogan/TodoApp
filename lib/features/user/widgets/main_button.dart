import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;
  final String text;
  final Function({required String email, required String password}) function;

  const MainButton({
    super.key,
    required this.mailController,
    required this.passwordController,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          elevation: const WidgetStatePropertyAll(8),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14.r),
              ),
            ),
          ),
          shadowColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
          backgroundColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
        ),
        onPressed: () => function(
          email: mailController.text,
          password: passwordController.text,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
