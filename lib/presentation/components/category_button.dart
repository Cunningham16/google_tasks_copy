import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: category.id != 1 ? category.name : null,
      icon: category.id == 1
          ? const Icon(
              Icons.star,
              size: 25,
            )
          : null,
    );
  }
}
