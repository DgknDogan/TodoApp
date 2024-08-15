import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_demo/utils/custom/custom_elevated_button.dart';
import 'package:firebase_demo/utils/custom/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/flushbars.dart';
import '../widgets/header_text.dart';
import '../cubit/forget_password_cubit.dart';

@RoutePage()
class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = useTextEditingController();
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            customFlushbar("success", Colors.green).show(context);
            mailController.clear();
            Future.delayed(
              const Duration(seconds: 2),
              () {
                context.router.maybePop();
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 60.h,
            ),
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: Column(
                children: [
                  SizedBox(height: 28.h),
                  const HeaderText(
                      title: "Forget Password",
                      text:
                          "It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum."),
                  SizedBox(height: 32.h),
                  _ForgetEmailForm(mailController: mailController),
                  SizedBox(height: 32.h),
                  _ContinueButton(mailController: mailController)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ForgetEmailForm extends StatelessWidget {
  const _ForgetEmailForm({
    required this.mailController,
  });

  final TextEditingController mailController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        return Form(
          key: (state as ForgetPasswordInitial).formKey,
          child: CustomTextField(
            textController: mailController,
            validator: (email) {
              if (!EmailValidator.validate(email!)) {
                return "Enter a valid email";
              } else {
                return null;
              }
            },
            hintText: 'Email',
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final TextEditingController mailController;

  const _ContinueButton({required this.mailController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: double.infinity,
      child: CustomElevatedButton(
        height: 60,
        width: double.infinity,
        onPressed: () {
          context
              .read<ForgetPasswordCubit>()
              .validateEmail(mailController.text);
        },
        text: 'Continue',
      ),
    );
  }
}
