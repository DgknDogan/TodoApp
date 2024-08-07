import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../../auth/cubit/profile_cubit.dart';
import '../cubit/home_cubit.dart';

final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> _surnameFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(homeCubit: context.read<HomeCubit>()),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 80.h,
              title: const Text("Profile"),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff3461FD),
                      Color(0xAA3461FD),
                      Color(0x003461FD),
                    ],
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Form(
                        key: _nameFormKey,
                        child: ProfileTextField(
                          controller: nameController,
                          text: "Name",
                          onPressed: context.read<ProfileCubit>().saveName,
                          hintText: state.name,
                          formKey: _nameFormKey,
                        )),
                    SizedBox(height: 20.h),
                    Form(
                      key: _surnameFormKey,
                      child: ProfileTextField(
                        controller: surnameController,
                        text: "Surname",
                        onPressed: context.read<ProfileCubit>().saveSurname,
                        hintText: state.surname,
                        formKey: _surnameFormKey,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Form(
                      key: _phoneFormKey,
                      child: ProfileTextField(
                        controller: phoneController,
                        text: "Phone",
                        onPressed: context.read<ProfileCubit>().savePhoneNumber,
                        hintText: state.phoneNumber,
                        formKey: _phoneFormKey,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    const FriendsSection(),
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

class FriendsSection extends StatelessWidget {
  const FriendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        state.newFriendRequestCount != 0
            ? Text(
                "${state.newFriendRequestCount} friend requests",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox(),
        SizedBox(height: 20.h),
        BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          return Column(children: [
            ...state.friendReqList.map((user) {
              return GestureDetector(
                onTap: () =>
                    context.router.push(FriendProfileRoute(friend: user)),
                child: FriendRequestCard(
                  name: user.name ?? "",
                ),
              );
            })
          ]);
        })
      ]);
    });
  }
}

class FriendRequestCard extends StatelessWidget {
  final String name;

  const FriendRequestCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 40.r,
              ),
              SizedBox(width: 20.w),
              Text(
                name,
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          Row(
            children: [
              CustomIconButton(
                funciton: context.read<ProfileCubit>().acceptFriendship,
                icon: const Icon(Icons.done),
                color: Colors.green,
                name: name,
              ),
              SizedBox(width: 10.w),
              CustomIconButton(
                funciton: context.read<ProfileCubit>().denyFriendship,
                icon: const Icon(Icons.cancel),
                color: Colors.red,
                name: name,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final Function(String) funciton;
  final Color color;
  final String name;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.funciton,
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () => funciton(name),
      icon: icon,
      iconSize: 40.r,
      color: color,
    );
  }
}

class ProfileTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Function(String) onPressed;
  final String hintText;
  final GlobalKey<FormState> formKey;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.onPressed,
    required this.hintText,
    required this.formKey,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
            TextFormField(
              controller: widget.controller,
              validator: (value) {
                if (value!.length < 2) {
                  return "Please enter a valid name";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                suffixIcon: context
                        .watch<ProfileCubit>()
                        .isTextFieldChanged(widget.controller, widget.hintText)
                    ? IconButton(
                        onPressed: () {
                          if (widget.formKey.currentState!.validate()) {
                            widget.onPressed(widget.controller.text);
                            widget.controller.clear();
                          }
                        },
                        icon: const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                      )
                    : const SizedBox(),
                hintText:
                    widget.hintText.isEmpty ? widget.text : widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff3461FD)),
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
