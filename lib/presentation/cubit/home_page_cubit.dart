import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentTabCubit extends Cubit<String> {
  CurrentTabCubit() : super("");

  void changeTab(String tab) => emit(tab);
}
