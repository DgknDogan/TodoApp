import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../user/widgets/alternative_auth_buttons.dart';
import '../../user/widgets/divider.dart';
import '../../user/widgets/flushbars.dart';
import '../../user/widgets/form_fields.dart';
import '../../user/widgets/header_text.dart';
import '../../user/widgets/main_button.dart';
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
            successFlushbar(state.message).show(context);
            mailController.clear();
            passwordController.clear();
            context.read<RegisterCubit>().initializeState();
            context.router.push(const LoginRoute());
          }
          if (state is RegisterError) {
            errorFlushbar(state.message).show(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
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
                    SignUpFormSection(
                      mailController: mailController,
                      passwordController: passwordController,
                    ),
                    SizedBox(height: 37.h),
                    CreateAccountSection(
                      mailController: mailController,
                      passwordController: passwordController,
                    ),
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
                EmailFormField(mailController: widget.mailController),
                SizedBox(height: 16.h),
                PasswordFormField(
                  passwordController: widget.passwordController,
                  showHidePassword:
                      context.read<RegisterCubit>().showHidePassword,
                  isObsecured: state.isObsecured,
                ),
                SizedBox(height: 12.h),
                const CheckBoxRow()
              ],
            ),
          ),
        );
      },
    );
  }
}

class CheckBoxRow extends StatelessWidget {
  const CheckBoxRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        state as RegisterInitial;
        return Row(
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              fillColor: const WidgetStatePropertyAll(Color(0xffF5F9FE)),
              checkColor: Colors.black,
              splashRadius: 0,
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
                    child: const Column(
                      children: [
                        Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce laoreet tellus nec ornare hendrerit. Vivamus a arcu tellus. Sed ut ex ut nisi porttitor convallis. Vestibulum efficitur metus id tristique auctor. Mauris mollis orci at leo luctus ornare. Ut elementum sapien non elit congue ullamcorper. Proin nec ex in nisl vestibulum consectetur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse ornare lorem et nisi sagittis, vel imperdiet urna faucibus.")
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
                // softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class CreateAccountSection extends StatelessWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const CreateAccountSection({
    super.key,
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
            SizedBox(height: 37.h),
            MainButton(
              mailController: mailController,
              passwordController: passwordController,
              text: "Create Account",
              function: context.read<RegisterCubit>().register,
            ),
            SizedBox(height: 16.h),
            SingInRowText(
              mailController: mailController,
              passwordController: passwordController,
            )
          ],
        );
      },
    );
  }
}

class SingInRowText extends StatelessWidget {
  const SingInRowText({
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
          "Do you have an account? ",
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
            context.router.push(const LoginRoute()),
            context.read<RegisterCubit>().initializeState(),
            mailController.clear(),
            passwordController.clear(),
          },
          child: Text(
            "Sign In",
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
