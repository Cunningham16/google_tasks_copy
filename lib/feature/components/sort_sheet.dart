import 'package:flutter/material.dart';

import 'category_list_button.dart';

class SortSheet extends StatelessWidget {
  const SortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Сортировка",
              textAlign: TextAlign.left,
            ),
          ),
          CategoryListButton(title: "В моем порядке", iconInfo: Icons.done),
          CategoryListButton(title: "По дате", iconInfo: Icons.done),
          CategoryListButton(title: "Недавно отмеченные", iconInfo: Icons.done)
        ],
      ),
    );
  }
}
