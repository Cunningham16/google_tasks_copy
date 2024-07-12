import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/service_locator.dart';

class CurrentTabCubit extends Cubit<int> {
  CurrentTabCubit()
      : super(serviceLocator<SharedPreferencesRepository>().getLastTab() ?? 0);

  void changeTab(int tab) => emit(tab);
}
