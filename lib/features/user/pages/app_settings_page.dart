import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/features/user/cubit/app_settings_cubit.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Settings",
        centerTitle: true,
        leadingOnPressed: () {
          context.router.maybePop();
        },
      ),
      body: BlocProvider(
        create: (context) => AppSettingsCubit(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [SizedBox(height: 20.h), const _ChangeThemeRow()],
          ),
        ),
      ),
    );
  }
}

class _ChangeThemeRow extends StatelessWidget {
  const _ChangeThemeRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Change Theme",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
              value: state.switchValue,
              onChanged: (value) {
                context.read<AppSettingsCubit>().changeSwitchValue(value);
              },
            )
          ],
        );
      },
    );
  }
}
