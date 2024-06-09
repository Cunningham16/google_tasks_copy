import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepositoryImpl implements SharedPreferencesRepository {
  late SharedPreferences _sp;

  Future<void> call() async {
    _sp = await SharedPreferences.getInstance();
  }

  @override
  String? getLastTab() => _sp.getString("currentTab");

  @override
  void setLastTab(String id) => _sp.setString("currentTab", id);
}
