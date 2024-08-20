import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_cubit.dart';

part '../state/app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final HomeCubit cubit;
  AppSettingsCubit({required this.cubit})
      : super(
          AppSettingsState(
            switchValue: false,
            isPageLoading: true,
          ),
        ) {
    getSwitchValue();
  }

  void changeSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("themeData", value);
    emit(state.copyWith(switchValue: value));
    cubit.changeTheme();
  }

  void getSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    final switchValue = prefs.getBool("themeData");
    if (switchValue != null) {
      emit(state.copyWith(switchValue: switchValue, isPageLoading: false));
    } else {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      final isDarkMode = brightness == Brightness.dark;
      emit(state.copyWith(switchValue: isDarkMode, isPageLoading: false));
    }
  }
}
