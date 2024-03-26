import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
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
                    tabs: <Widget>[
                      const CategoryButton(
                        icon: Icon(
                          Icons.star,
                          size: 20,
                        ),
                      ),
                      const CategoryButton(title: "Сегодня"),
                      const CategoryButton(title: "Сегодня"),
                      Tab(
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
                      )
                    ],
                    isScrollable: true,
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [TaskList(), TaskList(), TaskList()],
            )),
        bottomNavigationBar: const BottomBar(),
        drawerScrimColor: Colors.blue,
      ),
    );
  }
}
