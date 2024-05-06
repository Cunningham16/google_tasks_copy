import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/screens/create_list.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet(
      {super.key, required this.taskCategory, required this.tabController});

  final TaskCategory taskCategory;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final CategoryBloc bloc = context.read<CategoryBloc>();
              final newNameTab = await Navigator.of(context)
                  .push(CreateListScreen.route(taskCategory.name)) as String;
              if (!context.mounted) return;
              bloc.add(CategoryRenamed(taskCategory, newNameTab));
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                child: const Row(children: [Text("Переименовать список")])),
          ),
          InkWell(
            onTap: taskCategory.isDeletable
                ? () async {
                    Navigator.of(context).pop();
                    final bloc = context.read<CategoryBloc>();
                    final String? dialogMessage =
                        await _showWarningDeleteList(context) as String?;
                    if (dialogMessage == "approved") {
                      tabController.animateTo(1);
                      bloc.add(CategoryDeleted(taskCategory));
                    }
                  }
                : null,
            highlightColor: taskCategory.isDeletable
                ? Colors.black.withOpacity(0.09)
                : Colors.transparent,
            splashColor: taskCategory.isDeletable
                ? Colors.black.withOpacity(0.09)
                : Colors.transparent,
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Text("Удалить список",
                      style: TextStyle(
                          color: !taskCategory.isDeletable
                              ? Colors.black26
                              : Colors.black87))
                ])),
          ),
          Builder(builder: (context) {
            List<TaskItem> taskItems = context
                .read<TaskBloc>()
                .state
                .taskList
                .where((element) =>
                    element.category == taskCategory.id && element.isCompleted)
                .toList();
            return InkWell(
              onTap: taskItems.isNotEmpty
                  ? () async {
                      Navigator.of(context).pop();
                      final bloc = context.read<TaskBloc>();
                      final String? dialogStatus =
                          await _showWarningAllCleared(context) as String?;
                      if (dialogStatus == "approved") {
                        bloc.add(TaskClearedAllCompleted(taskCategory.id));
                      }
                    }
                  : null,
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(children: [
                    Text("Удалить выполненные задачи",
                        style: TextStyle(
                            color: taskItems.isEmpty
                                ? Colors.black26
                                : Colors.black87))
                  ])),
            );
          }),
        ],
      ),
    );
  }
}

Future<void> _showWarningAllCleared(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Удалить все выполненные задачи?"),
      content: const Text(
          "Все выполненные задачи будут навсегда удалены из этого списка"),
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

Future<void> _showWarningDeleteList(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Удалить этот список?"),
      content: const Text(
          "Все в этом списке будут удалены без возможности восстановления."),
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
