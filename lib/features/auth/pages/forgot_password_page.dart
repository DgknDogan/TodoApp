import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/flushbars.dart';
import '../widgets/form_fields.dart';
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
            successFlushbar("success").show(context);
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
            body: SafeArea(
              child: Container(
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
                    Form(
                        key: (state as ForgetPasswordInitial).formKey,
                        child: EmailFormField(mailController: mailController)),
                    SizedBox(height: 32.h),
                    ContinueButton(mailController: mailController)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  final TextEditingController mailController;

  const ContinueButton({super.key, required this.mailController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
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
        onPressed: () => {
          context
              .read<ForgetPasswordCubit>()
              .validateEmail(mailController.text),
        },
        child: Text(
          "Continue",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
