import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/auth/widgets/flushbars.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';
import 'package:firebase_demo/utils/custom/custom_elevated_button.dart';
import 'package:firebase_demo/utils/custom/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../../../utils/custom/custom_text_field.dart';
import '../widgets/alternative_auth_buttons.dart';
import '../widgets/divider.dart';
import '../widgets/header_text.dart';
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
            customFlushbar(state.message, Colors.red).show(context);
          }
          if (state is LoginSuccess) {
            customFlushbar(state.message, Colors.green).show(context);

            Future.delayed(
              const Duration(milliseconds: 2000),
              () {
                if (auth.currentUser?.displayName != null) {
                  context.router.replace(const InitialRoute());
                } else {
                  context.router.replace(const SetNameRoute());
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
            appBar: const CustomAppbar(
              leadingIcon: SizedBox(),
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HeaderText(
                    title: "Sign In",
                    text:
                        "It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.",
                  ),
                  SizedBox(height: 24.h),
                  _SignInFormSection(
                    mailController: mailController,
                    passwordController: passwordController,
                  ),
                  SizedBox(height: 10.h),
                  _ForgetPasswordText(
                    mailController: mailController,
                    passwordController: passwordController,
                  ),
                  SizedBox(height: 37.h),
                  _LoginSection(
                    mailController: mailController,
                    passwordController: passwordController,
                  ),
                  SizedBox(height: 16.h),
                  _SignUpTextRow(
                    mailController: mailController,
                    passwordController: passwordController,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SignInFormSection extends StatefulWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const _SignInFormSection({
    required this.mailController,
    required this.passwordController,
  });

  @override
  State<_SignInFormSection> createState() => _SignInFormSectionState();
}

class _SignInFormSectionState extends State<_SignInFormSection> {
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
                CustomTextField(
                  textController: widget.mailController,
                  validator: (email) {
                    if (!EmailValidator.validate(email!)) {
                      return "Enter a valid email";
                    } else {
                      return null;
                    }
                  },
                  hintText: "Email",
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  textController: widget.passwordController,
                  validator: (password) {
                    if (password!.isEmpty && password.length < 6) {
                      return "Enter a valid password";
                    } else {
                      return null;
                    }
                  },
                  hintText: "Password",
                  isObsecured: state.isObsecured,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 24.w),
                    child: GestureDetector(
                      onTap: () {
                        context.read<LoginCubit>().showHidePassword();
                      },
                      child: widget.passwordController.text.isNotEmpty
                          ? Icon(
                              state.isObsecured
                                  ? Icons.sunny
                                  : Icons.nightlight_round_outlined,
                              color: const Color(0xff7C8BA0),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ForgetPasswordText extends StatelessWidget {
  const _ForgetPasswordText({
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

class _LoginSection extends StatelessWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const _LoginSection({
    required this.mailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomElevatedButton(
              width: double.infinity,
              height: 60,
              onPressed: () {
                context.read<LoginCubit>().login(
                      email: mailController.text,
                      password: passwordController.text,
                    );
              },
              text: "Log In",
            ),
          ],
        );
      },
    );
  }
}

class _SignUpTextRow extends StatelessWidget {
  const _SignUpTextRow({
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
        CustomTextButton(
          text: "Sign Up",
          onPressed: () {
            if (!Navigator.canPop(context)) {
              context.router.replace(const CreateAccountRoute());
            } else {
              context.router.maybePop();
            }

            mailController.clear();
            passwordController.clear();
          },
        )
      ],
    );
  }
}
