import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/screens/create_list.dart';

import '../components/bottom_bar.dart';
import '../components/category_button.dart';
import '../components/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskCategory>>(
        stream:
            RepositoryProvider.of<TaskRepository>(context).watchCategories(),
        builder: (context, snapshotCtg) {
          return DefaultTabController(
            initialIndex: 0,
            length: 1 + snapshotCtg.data!.length,
            child: Scaffold(
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
                        tabs: List.from(snapshotCtg.data!
                            .map((e) => CategoryButton(category: e))
                            .toList())
                          ..add(Tab(
                            child: InkWell(
                              onTap: () async {
                                final newCategoryName =
                                    await Navigator.of(context).push<void>(
                                        CreateListScreen.route()) as String;
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
                    children: snapshotCtg.data!
                        .map((e) => TaskList(
                            filteredList: snapshotTasks.data
                                ?.where((element) => element.category == e.id)))
                        .toList(),
                  ),
                ),
              ),
              bottomNavigationBar: const BottomBar(),
              drawerScrimColor: Colors.blue,
            ),
          );
        });
  }
}
