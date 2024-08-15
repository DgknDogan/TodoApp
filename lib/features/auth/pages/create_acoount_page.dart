import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_demo/routes/app_router.gr.dart';
import 'package:firebase_demo/utils/custom/custom_elevated_button.dart';
import 'package:firebase_demo/utils/custom/custom_text_button.dart';
import 'package:firebase_demo/utils/custom/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/alternative_auth_buttons.dart';
import '../widgets/divider.dart';
import '../widgets/flushbars.dart';
import '../widgets/header_text.dart';
import '../cubit/register_cubit.dart';

@RoutePage()
class CreateAccountPage extends HookWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = useTextEditingController();
    final passwordController = useTextEditingController();
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            customFlushbar(state.message, Colors.green).show(context);
            Future.delayed(
              const Duration(seconds: 2),
              () {
                context.read<RegisterCubit>().initializeState();
                context.router.push(const LoginRoute());
                mailController.clear();
                passwordController.clear();
              },
            );
          }
          if (state is RegisterError) {
            customFlushbar(state.message, Colors.red).show(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
              width: width,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  const HeaderText(
                      title: "Sign Up",
                      text:
                          "It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum."),
                  SizedBox(height: 24.h),
                  _SignUpFormSection(
                    mailController: mailController,
                    passwordController: passwordController,
                  ),
                  SizedBox(height: 37.h),
                  _CreateAccountSection(
                    mailController: mailController,
                    passwordController: passwordController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SignUpFormSection extends StatefulWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const _SignUpFormSection({
    required this.mailController,
    required this.passwordController,
  });

  @override
  State<_SignUpFormSection> createState() => _SignUpFormSectionState();
}

class _SignUpFormSectionState extends State<_SignUpFormSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return SizedBox(
          width: 345.w,
          child: Form(
            key: (state as RegisterInitial).formkey,
            child: Column(
              children: [
                Row(
                  children: [
                    const FacebookButton(),
                    SizedBox(width: 20.w),
                    GoogleButton(
                      signInWithGoogle:
                          context.read<RegisterCubit>().loginWithGoogle,
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
                        context.read<RegisterCubit>().showHidePassword();
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
                SizedBox(height: 12.h),
                const _CheckBoxRow()
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CheckBoxRow extends StatelessWidget {
  const _CheckBoxRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        state as RegisterInitial;
        return Row(
          children: [
            Checkbox(
              isError: state.isError,
              value: state.isChecked,
              onChanged: (value) {
                context.read<RegisterCubit>().checkBox(value!);
              },
            ),
            SizedBox(width: 14.w),
            GestureDetector(
              onTap: () => showBottomSheet(
                context: context,
                backgroundColor: Colors.grey.shade200,
                builder: (context) {
                  return Container(
                    height: 300.h,
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            context.router.maybePop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce laoreet tellus nec ornare hendrerit. Vivamus a arcu tellus. Sed ut ex ut nisi porttitor convallis. Vestibulum efficitur metus id tristique auctor. Mauris mollis orci at leo luctus ornare. Ut elementum sapien non elit congue ullamcorper. Proin nec ex in nisl vestibulum consectetur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  );
                },
              ),
              child: Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(text: "I’m agree to "),
                    TextSpan(
                        text: "The Terms of Service ",
                        style: TextStyle(color: Color(0xff3461FD))),
                    TextSpan(text: "and"),
                    TextSpan(
                        text: " Privacy Policy",
                        style: TextStyle(color: Color(0xff3461FD))),
                  ],
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 13),
              ),
            )
          ],
        );
      },
    );
  }
}

class _CreateAccountSection extends StatelessWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const _CreateAccountSection({
    required this.mailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomElevatedButton(
                width: double.infinity,
                height: 60,
                onPressed: () {
                  context.read<RegisterCubit>().register(
                        email: mailController.text,
                        password: passwordController.text,
                      );
                },
                text: "Create Account"),
            SizedBox(height: 16.h),
            _SingInRowText(
              mailController: mailController,
              passwordController: passwordController,
            )
          ],
        );
      },
    );
  }
}

class _SingInRowText extends StatelessWidget {
  const _SingInRowText({
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
          "Do you have an account? ",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xff61677D),
              ),
        ),
        CustomTextButton(
          text: "Sign In",
          onPressed: () {
            context.router.push(const LoginRoute());
            context.read<RegisterCubit>().initializeState();
            mailController.clear();
            passwordController.clear();
          },
        )
      ],
    );
  }
}
