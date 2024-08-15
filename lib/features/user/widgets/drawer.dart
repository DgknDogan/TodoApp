import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/utils/custom/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/home_cubit.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).padding.top.h,
          horizontal: 10.w,
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.checklist_rtl_sharp,
                size: 30.r,
              ),
              title: Text(
                "Todos",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const TodoInitialRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle_sharp,
                size: 30.r,
              ),
              title: Text(
                "Profile",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const ProfileRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                size: 30.r,
              ),
              title: Text(
                "Social",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const SocialRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.message,
                size: 30.r,
              ),
              title: Text(
                "Messages",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const MessagesInitialRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 30.r,
              ),
              title: Text(
                "Settings",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const AppSettingsRoute());
              },
            ),
            const Spacer(),
            const _LogOutButton()
          ],
        ),
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      height: 60,
      width: double.infinity,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "You are logging out",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: Text("Are you sure?",
                  style: Theme.of(context).textTheme.bodySmall),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: const [_LogOutDialogButtons()],
            );
          },
        );
      },
      text: "Log out",
    );
  }
}

class _LogOutDialogButtons extends StatelessWidget {
  const _LogOutDialogButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
            height: 40,
            width: 60,
            onPressed: () {
              context.router.maybePop();
            },
            text: "No"),
        CustomElevatedButton(
          height: 40,
          width: 60,
          onPressed: () {
            context.read<HomeCubit>().logOut();
            context.read<HomeCubit>().cancelListener();
            context.router.maybePop();
            context.router.replace(const LoginRoute());
          },
          text: "Yes",
        ),
      ],
    );
  }
}
