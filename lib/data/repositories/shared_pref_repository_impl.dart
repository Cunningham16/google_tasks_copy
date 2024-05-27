import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepositoryImpl implements SharedPreferencesRepository {
  const SharedPrefRepositoryImpl({required SharedPreferences sp}) : _sp = sp;

  final SharedPreferences _sp;

  int? getLastTab() => _sp.getInt("currentTab");

  void setLastTab(int number) => _sp.setInt("currentTab", number);
}
