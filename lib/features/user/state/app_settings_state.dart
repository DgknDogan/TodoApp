part of '../cubit/app_settings_cubit.dart';

class AppSettingsState {
  final bool switchValue;
  final bool isPageLoading;

  AppSettingsState({
    required this.switchValue,
    required this.isPageLoading,
  });

  AppSettingsState copyWith({bool? switchValue, bool? isPageLoading}) {
    return AppSettingsState(
      switchValue: switchValue ?? this.switchValue,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    );
  }
}
