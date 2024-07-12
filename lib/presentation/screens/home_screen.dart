import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/data/entities/app_user/app_user.dart';

import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/domain/use_cases/category/save_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/logout_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/stream_app_user_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/cubit/home_page_cubit.dart';
import 'package:google_tasks/presentation/screens/settings_screen.dart';
import 'package:google_tasks/presentation/views/task_date_lists.dart';
import 'package:google_tasks/presentation/views/task_marked_list.dart';
import 'package:google_tasks/presentation/views/task_normal_list.dart';
import 'package:google_tasks/service_locator.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

import '../components/bottom_bar.dart';
import '../components/category_button.dart';

import "../screens/screens.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String get route => "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void changeCurrentTab(int currentTabIndex) {
    context.read<CurrentTabCubit>().changeTab(currentTabIndex);
    serviceLocator<SharedPreferencesRepository>().setLastTab(currentTabIndex);
  }

  @override
  void initState() {
    super.initState();

    CategoryBloc categoryBloc = context.read<CategoryBloc>();

    context.read<TaskBloc>().add(const TaskSubscribtionRequested());
    categoryBloc.add(const CategorySubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
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
                        context
                            .read<TaskBloc>()
                            .add(TaskUndoChanged(state.lastCompletedTask!.id));
                        context.read<TaskBloc>().add(const TaskLastDumped());
                      }),
                )).closed.then((value) =>
                    context.read<TaskBloc>().add(const TaskLastDumped()));
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
                          context.read<TaskBloc>().state.lastDeletedTask!;
                      context.read<TaskBloc>().add(TaskCreated(SaveTaskParams(
                          title: lastDeletedTask.title,
                          isCompleted: lastDeletedTask.isCompleted,
                          category: lastDeletedTask.category,
                          date: lastDeletedTask.date,
                          isFavorite: lastDeletedTask.isFavorite,
                          position: lastDeletedTask.position,
                          content: lastDeletedTask.content)));
                      context.read<TaskBloc>().add(const TaskLastDumped());
                    }),
              )).closed.then((value) =>
                  context.read<TaskBloc>().add(const TaskLastDumped()));
          },
        ),
        BlocListener<TaskBloc, TaskState>(
          listenWhen: (previous, current) {
            return previous.lastUpdatedCategoryTask !=
                    current.lastUpdatedCategoryTask &&
                current.lastUpdatedCategoryTask != null;
          },
          listener: (context, state) {
            final String nextCategoryName = context
                .read<CategoryBloc>()
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
                content: Text('Задача перемещена в список "$nextCategoryName"'),
                action: SnackBarAction(
                    label: "Отменить",
                    onPressed: () {
                      context
                          .read<TaskBloc>()
                          .add(const TaskUpdatedCategoryUndo());
                      context
                          .read<TaskBloc>()
                          .add(const TaskUpdatedCategoryDump());
                    }),
              )).closed.then((value) => context
                  .read<TaskBloc>()
                  .add(const TaskUpdatedCategoryDump()));
          },
        )
      ],
      child: StreamBuilder<AppUser>(
          stream: serviceLocator<StreamAppUserUseCase>().call(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
              if (state.categoryList.isEmpty) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              return DefaultTabController(
                initialIndex: serviceLocator<SharedPreferencesRepository>()
                        .getLastTab() ??
                    0,
                length: state.categoryList.length + 1,
                child: Builder(builder: (context) {
                  DefaultTabController.of(context).animation?.addListener(() {
                    if (DefaultTabController.of(context).indexIsChanging) {
                      int index = DefaultTabController.of(context).index;
                      changeCurrentTab(index);
                    } else {
                      int index = DefaultTabController.of(context)
                          .animation!
                          .value
                          .round();
                      changeCurrentTab(index);
                    }
                  });
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
                            stretch: true,
                            forceElevated: innerBoxIsScrolled,
                            leading: IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                context.pushNamed(SettingsScreen.route);
                              },
                            ),
                            actions: [
                              IconButton(
                                  icon: const Icon(Icons.account_circle),
                                  onPressed: () async {
                                    LogoutUseCase(
                                            sharedPreferencesRepository:
                                                serviceLocator<
                                                    SharedPreferencesRepository>(),
                                            authRepository: serviceLocator<
                                                AuthRepository>())
                                        .call();
                                  })
                            ],
                            title: const Text(
                              "Задачи",
                            ),
                            bottom: TabBar(
                              tabAlignment: TabAlignment.start,
                              tabs: List.from(state.categoryList.map((e) {
                                if (e.isFavoriteFlag) {
                                  return const Tab(
                                    icon: Icon(Icons.star),
                                  );
                                }
                                return CategoryButton(category: e);
                              }).toList())
                                ..add(Tab(
                                  child: InkWell(
                                    onTap: () async {
                                      final newCategoryName = await context
                                              .pushNamed(CreateListScreen.route)
                                          as String;

                                      if (!context.mounted) {
                                        return;
                                      } else {
                                        context.read<CategoryBloc>().add(
                                            CategoryCreated(SaveCategoryParams(
                                                name: newCategoryName,
                                                isDeleteable: true,
                                                sortType: SortTypes.byOwn)));
                                      }
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
                          //Следующий код ужасен, попытаюсь его устранить позже, но пока так
                          return TabBarView(
                            children: List.from(state.categoryList.map((e) {
                              if (state.categoryList.indexOf(e) == 0) {
                                if (e.sortType == SortTypes.byDate) {
                                  return TaskDateList(
                                      taskItems: taskState.taskList.where(
                                          (element) => element.isFavorite));
                                } else if (e.sortType == SortTypes.byMarked) {
                                  return TaskMarkedList(
                                      taskItems: taskState.taskList.where(
                                          (element) => element.isFavorite));
                                }
                              }

                              switch (e.sortType) {
                                case SortTypes.byOwn:
                                  return TaskNormalList(
                                      taskItems: taskState.taskList.where(
                                          (element) =>
                                              element.category == e.id));
                                case SortTypes.byDate:
                                  return TaskDateList(
                                      taskItems: taskState.taskList.where(
                                          (element) =>
                                              element.category == e.id));
                                case SortTypes.byMarked:
                                  return TaskMarkedList(
                                      taskItems: taskState.taskList.where(
                                          (element) =>
                                              element.category == e.id));
                                default:
                              }
                            }).toList()),
                          );
                        },
                      ),
                    ),
                    bottomNavigationBar: const BottomBar(),
                    drawerScrimColor: Colors.blue,
                  );
                }),
              );
            });
          }),
    );
  }
}
