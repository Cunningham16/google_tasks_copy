import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/feature/task_bloc/task_bloc.dart';

import '../components/bottom_bar.dart';
import '../components/category_button.dart';
import '../components/task_list.dart';
import '../routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      return DefaultTabController(
        initialIndex: 0,
        length: 1 + state.categoryList.length,
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
                    tabs: List.from(state.categoryList
                        .map((e) => CategoryButton(category: e))
                        .toList())
                      ..add(Tab(
                        child: InkWell(
                          onTap: () =>
                              context.go("/${RoutesLocation.createList}"),
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
              children: state.categoryList
                  .map((e) => TaskList(
                      filteredList: state.taskList
                          .where((element) => element.categoryId == e.id)))
                  .toList(),
            ),
          ),
          bottomNavigationBar: const BottomBar(),
          drawerScrimColor: Colors.blue,
        ),
      );
    });
  }
}
