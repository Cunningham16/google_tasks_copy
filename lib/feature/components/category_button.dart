import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, this.title, this.icon});

  final String? title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Tab(child: title != null ? const Text("Сегодня") : icon);
  }
}
