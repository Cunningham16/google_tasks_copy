import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepositoryImpl implements SharedPreferencesRepository {
  final SharedPreferences sp;

  const SharedPrefRepositoryImpl({required this.sp});

  @override
  int? getLastTab() => sp.getInt("tab");

  @override
  void setLastTab(int id) => sp.setInt("tab", id);

  @override
  int getFavoriteViewSort() {
    return sp.getInt("sortType_favorite") ?? 1;
  }

  @override
  void setFavoriteViewSort(SortTypes sortType) {
    sp.setInt("sortType_favorite", sortType.index);
  }
}
