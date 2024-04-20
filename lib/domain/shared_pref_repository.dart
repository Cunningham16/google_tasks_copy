import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  const SharedPreferencesRepository({required SharedPreferences sp}) : _sp = sp;

  final SharedPreferences _sp;

  int? getLastTab() => _sp.getInt("currentTab");

  void setLastTab(int number) => _sp.setInt("currentTab", number);
}
