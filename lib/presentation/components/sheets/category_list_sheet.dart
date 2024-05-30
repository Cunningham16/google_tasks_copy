import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

import '../category_select_button.dart';
import '../../screens/screens.dart';

class CategoryListSheet extends StatefulWidget {
  const CategoryListSheet({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<CategoryListSheet> createState() => _CategoryListSheetState();
}

class _CategoryListSheetState extends State<CategoryListSheet> {
  Future<void> _createTaskList() async {
    CategoryBloc bloc = context.read<CategoryBloc>();

    final newCategoryName = context.pushNamed(CreateListScreen.route) as String;

    if (!context.mounted) return;

    bloc.add(CategoryCreated(TaskCategoriesCompanion(
        name: Value(newCategoryName), sortType: const Value(SortTypes.byOwn))));
    Navigator.of(context).pop();
  }

  void _animateToCategory(int index) {
    widget.tabController.animateTo(index);
    Navigator.of(context).pop();
  }

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
                CategorySelectButton(
                  onTap: () => _animateToCategory(0),
                  title: "Избранные",
                  iconInfo: widget.tabController.index == 0
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
                      return CategorySelectButton(
                        onTap: () => _animateToCategory(index),
                        title: snapshot.data![index].name,
                        iconInfo: widget.tabController.index == index
                            ? Icons.done
                            : null,
                      );
                    }),
                const Divider(),
                CategorySelectButton(
                  onTap: () async => _createTaskList(),
                  title: "Создать список",
                  iconInfo: Icons.add,
                ),
              ],
            ),
          );
        });
  }
}
