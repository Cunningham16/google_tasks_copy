import 'package:flutter/material.dart';
import 'package:google_tasks/data/entities/category.entity.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(children: [
      Text(category.name),
    ]));
  }
}
