import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/feature/screens/create_list.dart';
import 'package:google_tasks/feature/task_bloc/task_bloc.dart';

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
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      //ЙОПАНЫЙ РОТ ЭТОГО КАЗИНО, БЛЯТЬ! emit.forEach не может следить за изменениями потоковых данных
      //поэтому используем этот костыль, вдруг он еще послужит хорошо
      return StreamBuilder<List<CategoryEntity>>(
          stream: state.categoryList,
          builder: (context, snapshot) {
            return DefaultTabController(
              initialIndex: 0,
              length: 1 + snapshot.data!.length,
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
                          tabs: List.from(snapshot.data!
                              .map((e) => CategoryButton(category: e))
                              .toList())
                            ..add(Tab(
                              child: InkWell(
                                onTap: () async {
                                  final newCategoryName =
                                      await Navigator.of(context).push<void>(
                                              CreateListScreen.route(
                                                  context.read<TaskBloc>()))
                                          as String;
                                  if (!context.mounted) return;
                                  context.read<TaskBloc>().add(
                                      CategoryCreateRequest(CategoryEntity(
                                          name: newCategoryName)));
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
                    children: snapshot.data!
                        .map((e) => TaskList(
                            filteredList: state.taskList.where(
                                (element) => element.categoryId == e.id)))
                        .toList(),
                  ),
                ),
                bottomNavigationBar: const BottomBar(),
                drawerScrimColor: Colors.blue,
              ),
            );
          });
    });
  }
}
