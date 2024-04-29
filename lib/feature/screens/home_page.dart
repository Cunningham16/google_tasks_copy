import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/shared_pref_repository.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/cubit/home_page_cubit.dart';
import 'package:google_tasks/feature/screens/create_list.dart';

import '../components/bottom_bar.dart';
import '../components/category_button.dart';
import '../components/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  void changeCurrentTab(
      int currentTabIndex, List<TasksWithCategories> categories) {
    TasksWithCategories currentTab = categories[currentTabIndex];
    //Сохраняем в локалку
    SharedPreferencesRepository sharedPreferencesRepository =
        context.read<SharedPreferencesRepository>();
    sharedPreferencesRepository.setLastTab(currentTab.taskCategory.id);
    //сохраняем в кубите
    context.read<CurrentTabCubit>().changeTab(currentTab.taskCategory.id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TasksWithCategories>>(
      stream: RepositoryProvider.of<TaskRepository>(context)
          .watchCategoriesWithTasks(),
      builder: (context, snapshot) {
        if (snapshot.data!.isNotEmpty) {
          tabController = TabController(
              length: snapshot.data!.length,
              vsync: this,
              initialIndex: snapshot.data!.isNotEmpty
                  ? snapshot.data!.indexWhere((element) =>
                      element.taskCategory.id ==
                      RepositoryProvider.of<SharedPreferencesRepository>(
                              context)
                          .getLastTab())
                  : 0);
          tabController.addListener(() {
            if (tabController.indexIsChanging ||
                tabController.index != tabController.previousIndex) {
              changeCurrentTab(tabController.index, snapshot.data!);
            }
          });
        }
        return BlocBuilder<CurrentTabCubit, int>(
          builder: (context, state) => Scaffold(
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
                      tabs: List.from(snapshot.data!
                          .map((e) => CategoryButton(category: e.taskCategory))
                          .toList())
                        ..add(Tab(
                          child: InkWell(
                            onTap: () async {
                              final newCategoryName =
                                  await Navigator.of(context).push<void>(
                                      CreateListScreen.route("")) as String;
                              if (!context.mounted) return;
                              RepositoryProvider.of<TaskRepository>(context)
                                  .saveCategory(TaskCategoriesCompanion(
                                      name: Value(newCategoryName)));
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
              body: TabBarView(
                controller: tabController,
                children: List.from(snapshot.data!.map((e) {
                  return TaskList(
                      sortType: e.taskCategory.sortType,
                      filteredList: e.taskItems);
                }).toList())
                  ..add(Container()),
              ),
            ),
            bottomNavigationBar: BottomBar(
              tabController: tabController,
              snapshot: snapshot.data![tabController.index],
            ),
            drawerScrimColor: Colors.blue,
          ),
        );
      },
    );
  }
}
