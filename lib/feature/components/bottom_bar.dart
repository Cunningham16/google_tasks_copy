import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/sort_sheet.dart';

import 'category_list_sheet.dart';
import 'create_task_sheet.dart';
import 'more_sheet.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
      {super.key, required this.tabController, required this.snapshot});

  //TODO: переделать логику таббаров, т.к. есть ощущение, что это антипаттерн
  final TabController tabController;
  final TasksWithCategories snapshot;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
      children: [
        IconButton(
          onPressed: () {
            _displayBottomSheet(
                context,
                CategoryListSheet(
                  tabController: tabController,
                ));
          },
          icon: const Icon(
            Icons.list_alt,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () {
            _displayBottomSheet(
                context,
                SortSheet(
                    category: snapshot.taskCategory,
                    tabController: tabController));
          },
          icon: const Icon(
            Icons.swap_vert,
            size: 25,
          ),
        ),
        if (tabController.index != 0)
          IconButton(
            onPressed: () {
              _displayBottomSheet(
                  context,
                  MoreSheet(
                    tabController: tabController,
                    snapshot: snapshot,
                  ));
            },
            icon: const Icon(
              Icons.more_horiz,
              size: 25,
            ),
          ),
        const Spacer(),
        FloatingActionButton(
          elevation: 0,
          onPressed: () {
            _displayBottomSheet(
                context,
                CreateTaskSheet(
                  isFavoriteFlag: tabController.index == 0,
                  taskCount: snapshot.taskItems.length,
                ));
          },
          child: const Icon(Icons.add, size: 25),
        )
      ],
    ));
  }
}

Future _displayBottomSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(children: [child]);
      });
}
