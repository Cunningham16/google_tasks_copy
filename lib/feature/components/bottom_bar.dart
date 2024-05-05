import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/components/sort_sheet.dart';
import 'package:google_tasks/feature/cubit/home_page_cubit.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';

import 'category_list_sheet.dart';
import 'create_task_sheet.dart';
import 'more_sheet.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.tabController});

  //TODO: переделать логику таббаров, т.к. есть ощущение, что это антипаттерн
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      int taskCategoryIndex = state.categoryList.indexWhere(
          (element) => element.id == context.watch<CurrentTabCubit>().state);
      TaskCategory taskCategory = state.categoryList[taskCategoryIndex];
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
                      category: taskCategory, tabController: tabController));
            },
            icon: const Icon(
              Icons.swap_vert,
              size: 25,
            ),
          ),
          if (taskCategory.id != 1)
            IconButton(
              onPressed: () {
                _displayBottomSheet(
                    context,
                    MoreSheet(
                      tabController: tabController,
                      taskCategory: taskCategory,
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
                    taskCount: context
                        .read<TaskBloc>()
                        .state
                        .taskList
                        .where((element) => element.category == taskCategory.id)
                        .length,
                  ));
            },
            child: const Icon(Icons.add, size: 25),
          )
        ],
      ));
    });
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
