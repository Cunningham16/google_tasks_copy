import 'package:flutter/material.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/presentation/views/completed_tasks_list.dart';
import 'package:intl/intl.dart';

import '../components/app_task.dart';

class TaskDateList extends StatefulWidget {
  const TaskDateList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskDateList> createState() => _TaskDateListState();
}

class _TaskDateListState extends State<TaskDateList> {
  void showSnackbar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: const Text(
            "Чтобы переместить задачу вверх или вниз в списке, отсортированном по дате, измените дату задачи"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Map<String, List<TaskItem>> groupListByDate(List<TaskItem> taskItems) {
    taskItems.sort((a, b) {
      if (a.date == null) {
        return 1;
      }
      if (b.date == null) {
        return 1;
      }
      return a.date!.compareTo(b.date!);
    });

    var list = taskItems.toList().map((element) => element.date).toList();

    Map<String, List<TaskItem>> map = {};

    for (int i = 0; i < list.length; i++) {
      if (list[i] == null) {
        map["Без даты"] =
            taskItems.where((element) => element.date == null).toList();
      } else {
        map[DateFormat.MMMd().format(list[i]!)] = taskItems
            .where((element) =>
                element.date != null &&
                DateFormat.MMMd().format(element.date!) ==
                    DateFormat.MMMd().format(list[i]!))
            .toList();
      }
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    Iterable<TaskItem> uncompleted =
        widget.taskItems.where((element) => element.isCompleted == false);
    Iterable<TaskItem> completed =
        widget.taskItems.where((element) => element.isCompleted == true);

    Map<String, List<TaskItem>> groupUncompletedByDate =
        groupListByDate(uncompleted.toList());

    return widget.taskItems.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: uncompleted.isNotEmpty
                      ? const EdgeInsets.only(top: 15.0)
                      : EdgeInsets.zero,
                  child: Column(
                    children: [
                      Column(
                          children: groupUncompletedByDate
                              .map((key, value) => MapEntry(
                                  key,
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.from([
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(key),
                                        )
                                      ])
                                        ..addAll(value
                                            .map((taskItem) => GestureDetector(
                                                  onLongPress: () =>
                                                      showSnackbar(),
                                                  child: AppTask(
                                                      taskId: taskItem.id,
                                                      hideChip: true),
                                                ))))))
                              .values
                              .toList()),
                      if (completed.isNotEmpty)
                        CompletedTasksList(
                            taskItems: completed
                                .where((element) => element.isCompleted))
                    ],
                  ),
                )),
          );
  }
}
