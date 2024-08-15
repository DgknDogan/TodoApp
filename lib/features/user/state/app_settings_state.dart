part of '../cubit/app_settings_cubit.dart';

class AppSettingsState {
  final bool switchValue;

  AppSettingsState({required this.switchValue});

  AppSettingsState copyWith({bool? switchValue}) {
    return AppSettingsState(
      switchValue: switchValue ?? this.switchValue,
    );
  }
}
