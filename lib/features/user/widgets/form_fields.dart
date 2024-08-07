import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController mailController;
  const EmailFormField({super.key, required this.mailController});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(14.r),
        ),
      ),
      child: TextFormField(
        controller: mailController,
        validator: (email) {
          if (!EmailValidator.validate(email!)) {
            return "Enter a valid email";
          } else {
            return null;
          }
        },
        cursorErrorColor: Colors.black,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
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
            borderSide: const BorderSide(color: Color(0xff3461FD)),
            borderRadius: BorderRadius.circular(14.r),
          ),
          border: InputBorder.none,
          hintText: "E-mail",
          hintStyle: TextStyle(
            color: const Color(0xff7C8BA0),
            fontSize: 16.r,
          ),
        ),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController passwordController;
  final Function showHidePassword;
  final bool isObsecured;

  const PasswordFormField({
    super.key,
    required this.passwordController,
    required this.showHidePassword,
    required this.isObsecured,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(14.r),
        ),
      ),
      child: TextFormField(
        onChanged: (value) {
          setState(() {});
        },
        controller: widget.passwordController,
        validator: (password) {
          if (password!.isEmpty && password.length < 6) {
            return "Enter a valid password";
          } else {
            return null;
          }
        },
        obscureText: widget.isObsecured,
        obscuringCharacter: "●",
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: const Color(0xffF5F9FE),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 18.h,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(14.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff3461FD)),
            borderRadius: BorderRadius.circular(14.r),
          ),
          suffixIconConstraints: const BoxConstraints(),
          border: InputBorder.none,
          hintText: "Password",
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: GestureDetector(
              onTap: () => {widget.showHidePassword()},
              child: widget.passwordController.text.isNotEmpty
                  ? Icon(
                      widget.isObsecured
                          ? Icons.sunny
                          : Icons.nightlight_round_outlined,
                      color: const Color(0xff7C8BA0),
                    )
                  : const SizedBox(),
            ),
          ),
          hintStyle: TextStyle(
            color: const Color(0xff7C8BA0),
            fontSize: 16.r,
          ),
        ),
      ),
    );
  }
}
