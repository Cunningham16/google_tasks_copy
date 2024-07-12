import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/use_cases/category/update_category_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';

import '../../screens/screens.dart';

class MoreSheet extends StatefulWidget {
  const MoreSheet(
      {super.key, required this.taskCategory, required this.tabController});

  final TaskCategory taskCategory;
  final TabController tabController;

  @override
  State<MoreSheet> createState() => _MoreSheetState();
}

class _MoreSheetState extends State<MoreSheet> {
  Future<String?> _showWarningDialog(
      BuildContext context, String title, String content) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Отмена")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop("approved");
              },
              child: const Text("Удалить"))
        ],
      ),
    );
  }

  Future<void> deleteTaskList() async {
    Navigator.of(context).pop();
    final bloc = context.read<CategoryBloc>();
    final String? dialogMessage = await _showWarningDialog(
        context,
        "Удалить этот список?",
        "Весь список с задачами внутри будет удален без возможности восстановления.");
    if (dialogMessage == "approved") {
      widget.tabController.animateTo(1);
      bloc.add(CategoryDeleted(widget.taskCategory));
    }
  }

  Future<void> deleteCompletedTasks() async {
    Navigator.of(context).pop();
    final bloc = context.read<TaskBloc>();
    final String? dialogStatus = await _showWarningDialog(
        context,
        "Удалить все выполненные задачи?",
        "Все выполненные задачи будут навсегда удалены из этого списка");
    if (dialogStatus == "approved") {
      bloc.add(TaskClearedAllCompleted(widget.taskCategory.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<TaskItem> completedTaskItems = context
        .read<TaskBloc>()
        .state
        .taskList
        .where((element) =>
            element.category == widget.taskCategory.id && element.isCompleted)
        .toList();
    return Container(
      width: deviceSize.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final CategoryBloc bloc = context.read<CategoryBloc>();
              final newNameTab =
                  await context.pushNamed(CreateListScreen.route) as String;
              if (!context.mounted) return;
              bloc.add(CategoryUpdated(UpdateCategoryParams(
                  id: widget.taskCategory.id,
                  modifiedCategory:
                      widget.taskCategory.copyWith(name: newNameTab))));
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                child: const Row(children: [Text("Переименовать список")])),
          ),
          InkWell(
            onTap: widget.taskCategory.isDeleteable
                ? () => deleteTaskList()
                : null,
            highlightColor: widget.taskCategory.isDeleteable
                ? Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.color
                    ?.withOpacity(0.09)
                : Colors.transparent,
            splashColor: widget.taskCategory.isDeleteable
                ? Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.color
                    ?.withOpacity(0.09)
                : Colors.transparent,
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Text("Удалить список",
                      style: TextStyle(
                          color: !widget.taskCategory.isDeleteable
                              ? Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color
                                  ?.withOpacity(0.26)
                              : Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color
                                  ?.withOpacity(0.87)))
                ])),
          ),
          InkWell(
            onTap: completedTaskItems.isNotEmpty
                ? () => deleteCompletedTasks()
                : null,
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Text("Удалить выполненные задачи",
                      style: TextStyle(
                          color: completedTaskItems.isEmpty
                              ? Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color
                                  ?.withOpacity(0.26)
                              : Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color
                                  ?.withOpacity(0.87)))
                ])),
          ),
        ],
      ),
    );
  }
}
