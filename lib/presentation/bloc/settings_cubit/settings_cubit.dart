import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/presentation/bloc/settings_cubit/settings_state.dart';
import 'package:google_tasks/service_locator.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
            themeMode:
                serviceLocator<SharedPreferencesRepository>().getThemeMode() ??
                    ThemeMode.system));

  void changeTheme(ThemeMode themeMode) {
    serviceLocator<SharedPreferencesRepository>().setThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }
}
