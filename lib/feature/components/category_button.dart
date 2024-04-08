import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(children: [
      Text(category.name),
    ]));
  }
}
