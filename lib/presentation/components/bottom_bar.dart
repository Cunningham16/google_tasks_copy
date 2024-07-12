import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/components/sheets/sort_sheet.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/cubit/home_page_cubit.dart';

import 'sheets/category_list_sheet.dart';
import 'sheets/create_task_sheet.dart';
import 'sheets/more_sheet.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      int tabIndex = context.watch<CurrentTabCubit>().state;
      TaskCategory taskCategory = state.categoryList[tabIndex];

      return BottomAppBar(
          child: Row(
        children: [
          IconButton(
            onPressed: () {
              _displayBottomSheet(
                  context,
                  CategoryListSheet(
                    tabController: DefaultTabController.of(context),
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
                    tabIndex: tabIndex,
                    category: taskCategory,
                  ));
            },
            icon: const Icon(
              Icons.swap_vert,
              size: 25,
            ),
          ),
          if (tabIndex != 0)
            IconButton(
              onPressed: () {
                _displayBottomSheet(
                    context,
                    MoreSheet(
                      taskCategory: taskCategory,
                      tabController: DefaultTabController.of(context),
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
                    isFavoriteFlag: tabIndex == 0,
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
