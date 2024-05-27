import 'package:flutter/material.dart';

//Это расширение для того, чтобы отслеживать как свайп, так и переключение кнопками
extension TabControllerExtensions on TabController {
  void onIndexChange(final void Function() callback) {
    addListener(() {
      if (indexIsChanging || index != previousIndex) {
        callback();
      }
    });
  }
}
