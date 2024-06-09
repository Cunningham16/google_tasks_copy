import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/domain/use_cases/save_category_use_case.dart';
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

    bloc.add(CategoryCreated(SaveCategoryParams(
        name: newCategoryName, isDeleteable: true, sortType: SortTypes.byOwn)));
    Navigator.of(context).pop();
  }

  void _animateToCategory(int index) {
    widget.tabController.animateTo(index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
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
                itemCount: state.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container();
                  }
                  return CategorySelectButton(
                    onTap: () => _animateToCategory(index),
                    title: state.categoryList[index].name,
                    iconInfo:
                        widget.tabController.index == index ? Icons.done : null,
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
