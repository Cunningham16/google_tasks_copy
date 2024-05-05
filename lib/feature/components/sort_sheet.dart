import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/shared/sort_types.dart';

import 'category_list_button.dart';

class SortSheet extends StatelessWidget {
  const SortSheet(
      {super.key, required this.category, required this.tabController});

  final TaskCategory category;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Сортировка",
              textAlign: TextAlign.left,
            ),
          ),
          if (tabController.index != 0)
            CategoryListButton(
              title: "В моем порядке",
              iconInfo:
                  category.sortType == SortTypes.byOwn ? Icons.done : null,
              onTap: () {
                context
                    .read<CategoryBloc>()
                    .add(CategoryChangedSort(category, SortTypes.byOwn));
                Navigator.of(context).pop();
              },
            ),
          CategoryListButton(
              title: "По дате",
              iconInfo:
                  category.sortType == SortTypes.byDate ? Icons.done : null,
              onTap: () {
                context
                    .read<CategoryBloc>()
                    .add(CategoryChangedSort(category, SortTypes.byDate));
                Navigator.of(context).pop();
              }),
          CategoryListButton(
              title: "Недавно отмеченные",
              iconInfo:
                  category.sortType == SortTypes.byMarked ? Icons.done : null,
              onTap: () {
                context
                    .read<CategoryBloc>()
                    .add(CategoryChangedSort(category, SortTypes.byMarked));
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
