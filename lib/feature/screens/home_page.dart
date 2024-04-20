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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    context.read<CurrentTabCubit>().changeTab(
        context.read<SharedPreferencesRepository>().getLastTab() as int);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeCurrentTab(int currentTab) {
    SharedPreferencesRepository sharedPreferencesRepository =
        context.read<SharedPreferencesRepository>();
    sharedPreferencesRepository.setLastTab(currentTab);
    //сохраняем в кубите
    context
        .read<CurrentTabCubit>()
        .changeTab(sharedPreferencesRepository.getLastTab() as int);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskCategory>>(
      stream: RepositoryProvider.of<TaskRepository>(context).watchCategories(),
      builder: (context, snapshotCtg) {
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
                    snap: true,
                    forceElevated: innerBoxIsScrolled,
                    title: const Text(
                      "Задачи",
                    ),
                    bottom: TabBar(
                      tabAlignment: TabAlignment.start,
                      onTap: (value) => changeCurrentTab(value),
                      tabs: List.from(snapshotCtg.data!
                          .map((e) => CategoryButton(category: e))
                          .toList())
                        ..add(Tab(
                          child: InkWell(
                            onTap: () async {
                              final newCategoryName =
                                  await Navigator.of(context)
                                          .push<void>(CreateListScreen.route())
                                      as String;
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
              body: StreamBuilder(
                stream: RepositoryProvider.of<TaskRepository>(context)
                    .watchAllTasks(),
                builder: (context, snapshotTasks) => TabBarView(
                  children: snapshotCtg.data!.map((e) {
                    print(snapshotTasks.data);
                    return TaskList(
                        filteredList: snapshotTasks.data
                            ?.where((element) => element.category == e.id));
                  }).toList(),
                ),
              ),
            ),
            bottomNavigationBar: const BottomBar(),
            drawerScrimColor: Colors.blue,
          ),
        );
      },
    );
  }
}
