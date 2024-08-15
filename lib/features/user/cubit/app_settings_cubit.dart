import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part '../state/app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
      : super(
          AppSettingsState(
            switchValue: false,
          ),
        ) {
    getSwitchValue();
  }

  void changeSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("themeData", value);
    emit(state.copyWith(switchValue: value));
  }

  void getSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    final switchValue = prefs.getBool("themeData");
    emit(state.copyWith(switchValue: switchValue));
  }
}
