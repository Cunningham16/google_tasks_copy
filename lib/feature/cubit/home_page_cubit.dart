import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentTabCubit extends Cubit<int> {
  CurrentTabCubit() : super(1);

  void changeTab(int tab) => emit(tab);
}
