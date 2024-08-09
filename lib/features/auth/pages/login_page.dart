import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../../user/widgets/alternative_auth_buttons.dart';
import '../../user/widgets/divider.dart';
import '../../user/widgets/flushbars.dart';
import '../../user/widgets/form_fields.dart';
import '../../user/widgets/header_text.dart';
import '../../user/widgets/main_button.dart';
import '../cubit/login_cubit.dart';

@RoutePage()
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = useTextEditingController();
    final passwordController = useTextEditingController();
    FirebaseAuth auth = FirebaseAuth.instance;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailed) {
            errorFlushbar(state.message).show(context);
          }
          if (state is LoginSuccess) {
            successFlushbar(state.message).show(context);

            Future.delayed(
              const Duration(milliseconds: 2000),
              () {
                if (auth.currentUser?.displayName != null) {
                  context.router.push(const HomeRoute());
                } else {
                  context.router.push(const SetNameRoute());
                }
                context.read<LoginCubit>().initializeState();
                mailController.clear();
                passwordController.clear();
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    const HeaderText(
                      title: "Sign In",
                      text:
                          "It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.",
                    ),
                    SizedBox(height: 24.h),
                    SignUpFormSection(
                      mailController: mailController,
                      passwordController: passwordController,
                    ),
                    SizedBox(height: 32.h),
                    LoginSection(
                      mailController: mailController,
                      passwordController: passwordController,
                    )
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

class SignUpFormSection extends StatefulWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const SignUpFormSection({
    super.key,
    required this.mailController,
    required this.passwordController,
  });

  @override
  State<SignUpFormSection> createState() => _SignUpFormSectionState();
}

class _SignUpFormSectionState extends State<SignUpFormSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: 345.w,
          child: Form(
            key: (state as LoginInitial).formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const FacebookButton(),
                    SizedBox(width: 20.w),
                    GoogleButton(
                      signInWithGoogle:
                          context.read<LoginCubit>().loginWithGoogle,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const ButtonFormDivider(),
                SizedBox(height: 16.h),
                EmailFormField(mailController: widget.mailController),
                SizedBox(height: 16.h),
                PasswordFormField(
                  passwordController: widget.passwordController,
                  showHidePassword: context.read<LoginCubit>().showHidePassword,
                  isObsecured: state.isObsecured,
                ),
                SizedBox(height: 8.h),
                ForgetPasswordText(
                  mailController: widget.mailController,
                  passwordController: widget.passwordController,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({
    super.key,
    required this.mailController,
    required this.passwordController,
  });

  final TextEditingController mailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        state as LoginInitial;
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: const WidgetStatePropertyAll(Color(0xffF5F9FE)),
                    checkColor: Colors.black,
                    splashRadius: 0,
                    value: state.isRemembered,
                    onChanged: (value) =>
                        context.read<LoginCubit>().checkBox(value!),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () => {
                  context.router.push(const ForgotPasswordRoute()),
                  context.read<LoginCubit>().initializeState(),
                  mailController.clear(),
                  passwordController.clear(),
                },
                child: Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff7C8BA0),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class LoginSection extends StatelessWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const LoginSection(
      {super.key,
      required this.mailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          children: [
            MainButton(
              mailController: mailController,
              passwordController: passwordController,
              text: "Log In",
              function: context.read<LoginCubit>().login,
            ),
            SignUpTextRow(
              mailController: mailController,
              passwordController: passwordController,
            )
          ],
        );
      },
    );
  }
}

class SignUpTextRow extends StatelessWidget {
  const SignUpTextRow({
    super.key,
    required this.mailController,
    required this.passwordController,
  });

  final TextEditingController mailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: const Color(0xff61677D),
            fontSize: 14.sp,
          ),
        ),
        TextButton(
          style: const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size.zero),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: () => {
            context.router.replace(const CreateAccountRoute()),
            mailController.clear(),
            passwordController.clear(),
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: const Color(0xff2A4ECA),
              fontSize: 14.sp,
            ),
          ),
        )
      ],
    );
  }
}
