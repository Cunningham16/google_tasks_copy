import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/bloc/settings_cubit/settings_cubit.dart';
import 'package:google_tasks/presentation/bloc/settings_cubit/settings_state.dart';
import 'package:google_tasks/presentation/screens/screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static String get route => "settings";

  @override
  Widget build(BuildContext context) {
    String getMode(ThemeMode themeMode) {
      if (themeMode == ThemeMode.dark) {
        return "Темная";
      } else if (themeMode == ThemeMode.light) {
        return "Светлая";
      } else if (themeMode == ThemeMode.system) {
        return "Системные настройки по умолчанию";
      } else {
        return "";
      }
    }

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go(HomeScreen.route);
              },
            ),
            title: const Text(
              "Настройки",
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text(
                  "Тема",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(getMode(state.themeMode)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, settingsState) => AlertDialog(
                                title: const Text("Выберите тему"),
                                actions: [
                                  RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: ThemeMode.dark,
                                    groupValue: settingsState.themeMode,
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeTheme(ThemeMode.dark);
                                    },
                                    title: Text(getMode(ThemeMode.dark)),
                                  ),
                                  RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: ThemeMode.light,
                                    groupValue: settingsState.themeMode,
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeTheme(ThemeMode.light);
                                    },
                                    title: Text(getMode(ThemeMode.light)),
                                  ),
                                  RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: ThemeMode.system,
                                    groupValue: settingsState.themeMode,
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeTheme(ThemeMode.system);
                                    },
                                    title: Text(getMode(ThemeMode.system)),
                                  ),
                                ]),
                          ));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
