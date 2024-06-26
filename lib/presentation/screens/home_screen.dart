import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/domain/use_cases/save_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/views/task_date_lists.dart';
import 'package:google_tasks/presentation/views/task_marked_list.dart';
import 'package:google_tasks/presentation/views/task_normal_list.dart';
import 'package:google_tasks/service_locator.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

import '../components/bottom_bar.dart';
import '../components/category_button.dart';
import "../../utils/extensions/tab_controller_extensions.dart";

import "../screens/screens.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String get route => "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  void changeCurrentTab(int currentTabIndex, List<TaskCategory> categories) {
    TaskCategory currentTab = categories[currentTabIndex];
    serviceLocator<SharedPreferencesRepository>().setLastTab(currentTab.id);
  }

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
              listenWhen: (previous, current) =>
                  previous.lastCompletedTask != current.lastCompletedTask &&
                  current.lastCompletedTask != null,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    behavior: SnackBarBehavior.floating,
                    content: state.lastCompletedTask!.isCompleted
                        ? const Text(
                            "Задача отмечена как невыполненная",
                          )
                        : const Text("Задача выполнена"),
                    action: SnackBarAction(
                        label: "Отменить",
                        onPressed: () {
                          serviceLocator<TaskBloc>().add(
                              TaskUndoChanged(state.lastCompletedTask!.id));
                          serviceLocator<TaskBloc>()
                              .add(const TaskLastDumped());
                        }),
                  )).closed.then((value) =>
                      serviceLocator<TaskBloc>().add(const TaskLastDumped()));
              }),
          BlocListener<TaskBloc, TaskState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTask != current.lastDeletedTask,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  behavior: SnackBarBehavior.floating,
                  content: const Text("Задача удалена"),
                  action: SnackBarAction(
                      label: "Отменить",
                      onPressed: () {
                        TaskItem lastDeletedTask =
                            serviceLocator<TaskBloc>().state.lastDeletedTask!;
                        serviceLocator<TaskBloc>().add(TaskCreated(
                            SaveTaskParams(
                                title: lastDeletedTask.title,
                                isCompleted: lastDeletedTask.isCompleted,
                                category: lastDeletedTask.category,
                                date: lastDeletedTask.date,
                                isFavorite: lastDeletedTask.isFavorite,
                                position: lastDeletedTask.position,
                                content: lastDeletedTask.content)));
                        serviceLocator<TaskBloc>().add(const TaskLastDumped());
                      }),
                )).closed.then((value) =>
                    serviceLocator<TaskBloc>().add(const TaskLastDumped()));
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listenWhen: (previous, current) {
              return previous.lastUpdatedCategoryTask !=
                      current.lastUpdatedCategoryTask &&
                  current.lastUpdatedCategoryTask != null;
            },
            listener: (context, state) {
              final String nextCategoryName = serviceLocator<CategoryBloc>()
                  .state
                  .categoryList
                  .firstWhere((element) =>
                      element.id ==
                      state.taskList
                          .firstWhere((element) =>
                              element.id == state.lastUpdatedCategoryTask!.id)
                          .category)
                  .name;
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  behavior: SnackBarBehavior.floating,
                  content:
                      Text('Задача перемещена в список "$nextCategoryName"'),
                  action: SnackBarAction(
                      label: "Отменить",
                      onPressed: () {
                        serviceLocator<TaskBloc>()
                            .add(const TaskUpdatedCategoryUndo());
                        serviceLocator<TaskBloc>()
                            .add(const TaskUpdatedCategoryDump());
                      }),
                )).closed.then((value) => serviceLocator<TaskBloc>()
                    .add(const TaskUpdatedCategoryDump()));
            },
          )
        ],
        child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state.categoryList.isEmpty) {
            return const Center(child: CupertinoActivityIndicator());
          }
          tabController = TabController(
              length: state.categoryList.length,
              vsync: this,
              initialIndex: state.categoryList.isNotEmpty
                  ? state.categoryList.indexWhere((element) =>
                      element.id ==
                      serviceLocator<SharedPreferencesRepository>()
                          .getLastTab())
                  : 0);
          tabController.onIndexChange(
              () => changeCurrentTab(tabController.index, state.categoryList));
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    clipBehavior: Clip.antiAlias,
                    surfaceTintColor: Colors.white,
                    centerTitle: true,
                    pinned: true,
                    floating: true,
                    snap: false,
                    forceElevated: innerBoxIsScrolled,
                    title: const Text(
                      "Задачи",
                    ),
                    bottom: TabBar(
                      controller: tabController,
                      tabAlignment: TabAlignment.start,
                      tabs: List.from(state.categoryList
                          .map((e) => CategoryButton(category: e))
                          .toList())
                        ..add(Tab(
                          child: InkWell(
                            onTap: () async {
                              final newCategoryName = await context
                                  .pushNamed(CreateListScreen.route) as String;
                              if (!context.mounted) return;
                              context.read<CategoryBloc>().add(CategoryCreated(
                                  SaveCategoryParams(
                                      name: newCategoryName,
                                      isDeleteable: true,
                                      sortType: SortTypes.byOwn)));
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 20),
                                Gap(5),
                                Text("Добавить")
                              ],
                            ),
                          ),
                        )),
                      isScrollable: true,
                    ),
                  ),
                ];
              },
              body: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, taskState) {
                  return TabBarView(
                    controller: tabController,
                    children: List.from(state.categoryList.map((e) {
                      //Категория с положительным флагом должна быть одна
                      if (e.isFavoriteFlag) {
                        switch (e.sortType) {
                          case SortTypes.byDate:
                            return TaskDateList(
                                taskItems: taskState.taskList
                                    .where((element) => element.isFavorite));
                          case SortTypes.byMarked:
                            return TaskMarkedList(
                                taskItems: taskState.taskList
                                    .where((element) => element.isFavorite));
                          default:
                        }
                      }
                      switch (e.sortType) {
                        case SortTypes.byOwn:
                          return TaskNormalList(
                              taskItems: taskState.taskList.where(
                                  (element) => element.category == e.id));
                        case SortTypes.byDate:
                          return TaskDateList(
                              taskItems: taskState.taskList.where(
                                  (element) => element.category == e.id));
                        case SortTypes.byMarked:
                          return TaskMarkedList(
                              taskItems: taskState.taskList.where(
                                  (element) => element.category == e.id));
                        default:
                      }
                    }).toList()),
                  );
                },
              ),
            ),
            bottomNavigationBar: BottomBar(
              tabController: tabController,
            ),
            drawerScrimColor: Colors.blue,
          );
        }),
      );
}
