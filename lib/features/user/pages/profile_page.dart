import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';
import 'package:firebase_demo/utils/custom/custom_suffix_widget.dart';
import 'package:firebase_demo/utils/custom/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/profile_cubit.dart';
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
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    nameController = TextEditingController();
    surnameController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

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
            appBar: CustomAppbar(
              title: "Profile",
              centerTitle: false,
              leadingOnPressed: () {
                context.read<ProfileCubit>().cancelListener();
                context.router.maybePop();
              },
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Form(
                    onChanged: () {
                      setState(() {});
                    },
                    key: _nameFormKey,
                    child: CustomTextField(
                      textController: nameController,
                      validator: (name) {
                        if (name!.length < 2) {
                          return "Please enter a valid name";
                        } else {
                          return null;
                        }
                      },
                      hintText: state.name.isEmpty ? "Name" : state.name,
                      suffixIcon: CustomSuffixWidget(
                        isTextFieldChanged:
                            context.watch<ProfileCubit>().isTextFieldChanged(
                                  nameController.text,
                                  state.name,
                                ),
                        controller: nameController,
                        text: nameController.text,
                        onPressed: () {
                          if (_nameFormKey.currentState!.validate()) {
                            context
                                .read<ProfileCubit>()
                                .saveName(nameController.text);
                            nameController.clear();
                          }
                        },
                        hintText: state.name,
                        formKey: _nameFormKey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    onChanged: () {
                      setState(() {});
                    },
                    key: _surnameFormKey,
                    child: CustomTextField(
                      textController: surnameController,
                      validator: (surname) {
                        if (surname!.length < 2) {
                          return "Please enter a valid surname";
                        } else {
                          return null;
                        }
                      },
                      hintText:
                          state.surname.isEmpty ? "Surname" : state.surname,
                      suffixIcon: CustomSuffixWidget(
                        isTextFieldChanged:
                            context.watch<ProfileCubit>().isTextFieldChanged(
                                  surnameController.text,
                                  state.surname,
                                ),
                        controller: surnameController,
                        text: surnameController.text,
                        onPressed: () {
                          if (_surnameFormKey.currentState!.validate()) {
                            context
                                .read<ProfileCubit>()
                                .saveSurname(surnameController.text);
                            surnameController.clear();
                          }
                        },
                        hintText: state.surname,
                        formKey: _surnameFormKey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    onChanged: () {
                      setState(() {});
                    },
                    key: _phoneFormKey,
                    child: CustomTextField(
                      textController: phoneController,
                      validator: (phoneNumber) {
                        if (phoneNumber!.length < 2) {
                          return "Please enter a valid phone number";
                        } else {
                          return null;
                        }
                      },
                      hintText: state.phoneNumber.isEmpty
                          ? "Phone"
                          : state.phoneNumber,
                      suffixIcon: CustomSuffixWidget(
                        isTextFieldChanged:
                            context.watch<ProfileCubit>().isTextFieldChanged(
                                  phoneController.text,
                                  state.phoneNumber,
                                ),
                        controller: phoneController,
                        text: phoneController.text,
                        onPressed: () {
                          if (_phoneFormKey.currentState!.validate()) {
                            context
                                .read<ProfileCubit>()
                                .savePhoneNumber(phoneController.text);
                            phoneController.clear();
                          }
                        },
                        hintText: state.phoneNumber,
                        formKey: _phoneFormKey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Divider(),
                  SizedBox(height: 20.h),
                  const _FriendsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FriendsSection extends StatelessWidget {
  const _FriendsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.newFriendRequestCount != 0
                ? Text(
                    "${state.newFriendRequestCount} friend requests",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : const SizedBox(),
            SizedBox(height: 20.h),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (!state.isFriendshipListLoading) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...state.friendReqList.map(
                          (user) {
                            return GestureDetector(
                              onTap: () => context.router
                                  .push(FriendProfileRoute(friend: user)),
                              child: _FriendRequestCard(
                                name: user.name ?? "",
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        );
      },
    );
  }
}

class _FriendRequestCard extends StatelessWidget {
  final String name;

  const _FriendRequestCard({required this.name});

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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              _CustomIconButton(
                funciton: context.read<ProfileCubit>().acceptFriendship,
                icon: const Icon(Icons.done),
                color: Colors.green,
                name: name,
              ),
              SizedBox(width: 10.w),
              _CustomIconButton(
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

class _CustomIconButton extends StatelessWidget {
  final Icon icon;
  final Function(String) funciton;
  final Color color;
  final String name;

  const _CustomIconButton({
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
