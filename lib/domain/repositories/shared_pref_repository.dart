import 'package:flutter/material.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

abstract class SharedPreferencesRepository {
  int? getLastTab();

  void setLastTab(int id);

  ThemeMode? getThemeMode();

  void setThemeMode(ThemeMode themeMode);

  void setFavoriteViewSort(SortTypes sortType);

  int getFavoriteViewSort();
}
