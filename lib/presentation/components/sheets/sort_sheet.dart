import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/use_cases/update_category_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

import '../category_select_button.dart';

class SortSheet extends StatefulWidget {
  const SortSheet(
      {super.key, required this.category, required this.tabController});

  final TaskCategory category;
  final TabController tabController;

  @override
  State<SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<SortSheet> {
  void _selectSortType(SortTypes sortType) {
    context.read<CategoryBloc>().add(CategoryUpdated(UpdateCategoryParams(
        id: widget.category.id,
        modifiedCategory: widget.category.copyWith(sortType: sortType))));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Сортировка",
              textAlign: TextAlign.left,
            ),
          ),
          if (widget.tabController.index != 0)
            CategorySelectButton(
              title: "В моем порядке",
              iconInfo: widget.category.sortType == SortTypes.byOwn
                  ? Icons.done
                  : null,
              onTap: () => _selectSortType(SortTypes.byOwn),
            ),
          CategorySelectButton(
              title: "По дате",
              iconInfo: widget.category.sortType == SortTypes.byDate
                  ? Icons.done
                  : null,
              onTap: () => _selectSortType(SortTypes.byDate)),
          CategorySelectButton(
              title: "Недавно отмеченные",
              iconInfo: widget.category.sortType == SortTypes.byMarked
                  ? Icons.done
                  : null,
              onTap: () => _selectSortType(SortTypes.byMarked))
        ],
      ),
    );
  }
}
