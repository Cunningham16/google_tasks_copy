import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task_repository.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/screens/create_list.dart';
import 'package:google_tasks/feature/shared/sort_types.dart';

import 'category_list_button.dart';

class CategoryListSheet extends StatelessWidget {
  const CategoryListSheet({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskCategory>>(
        stream:
            RepositoryProvider.of<TaskRepository>(context).watchCategories(),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CategoryListButton(
                  onTap: () {
                    tabController.animateTo(0);
                    Navigator.of(context).pop();
                  },
                  title: "Избранные",
                  iconInfo: tabController.index == 0
                      ? Icons.star
                      : Icons.star_border_outlined,
                ),
                const Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container();
                      }
                      return CategoryListButton(
                        onTap: () {
                          tabController.animateTo(index);
                          Navigator.of(context).pop();
                        },
                        title: snapshot.data![index].name,
                        iconInfo:
                            tabController.index == index ? Icons.done : null,
                      );
                    }),
                const Divider(),
                CategoryListButton(
                  onTap: () async {
                    final newCategoryName = await Navigator.of(context)
                        .push<void>(CreateListScreen.route("")) as String;
                    if (!context.mounted) return;
                    context.read<CategoryBloc>().add(CategoryCreated(
                        TaskCategoriesCompanion(
                            name: drift.Value(newCategoryName),
                            sortType: const drift.Value(SortTypes.byOwn))));
                    Navigator.of(context).pop();
                  },
                  title: "Создать список",
                  iconInfo: Icons.add,
                ),
              ],
            ),
          );
        });
  }
}
