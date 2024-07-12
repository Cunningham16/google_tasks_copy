import 'package:google_tasks/utils/enums/sort_types.dart';

abstract class SharedPreferencesRepository {
  int? getLastTab();

  void setLastTab(int id);

  void setFavoriteViewSort(SortTypes sortType);

  int getFavoriteViewSort();
}
