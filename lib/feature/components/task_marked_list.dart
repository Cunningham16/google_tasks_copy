import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';
import 'package:intl/intl.dart';

import 'app_task.dart';

class TaskMarkedList extends StatefulWidget {
  const TaskMarkedList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskMarkedList> createState() => _TaskMarkedListState();
}

class _TaskMarkedListState extends State<TaskMarkedList> {
  @override
  Widget build(BuildContext context) {
    Iterable<TaskItem> uncompleted =
        widget.taskItems.where((element) => element.isCompleted == false);
    Iterable<TaskItem> completed =
        widget.taskItems.where((element) => element.isCompleted == true);

    final Map<String, List<TaskItem>> sortedTaskList =
        createMarkedMap(uncompleted.toList());
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
                          children: sortedTaskList
                              .map((key, value) {
                                return MapEntry(
                                    key,
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.from([
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(key),
                                          )
                                        ])
                                          ..addAll(value.map((e) => GestureDetector(
                                            onLongPress: () {
                                              ScaffoldMessenger.of(context)
                                                ..clearSnackBars()
                                                ..showSnackBar(SnackBar(
                                                  content: const Text(
                                                      "Перемещать задачи в этом режиме просмотра нельзя. Выберите другой режим просмотра"),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8.0)),
                                                  behavior: SnackBarBehavior
                                                      .floating,
                                                ));
                                            },
                                            child: AppTask(
                                                  task: e,
                                                ),
                                          )))));
                              })
                              .values
                              .toList()),
                      if (completed.isNotEmpty)
                        Column(
                          children: [
                            const Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            CompletedTasksList(
                                taskItems: completed
                                    .where((element) => element.isCompleted))
                          ],
                        )
                    ],
                  ),
                )),
          );
  }
}

Map<String, List<TaskItem>> createMarkedMap(List<TaskItem> taskItems) {
  Map<String, List<TaskItem>> map = {};
  //буду еще ебаться с этим.
  //TODO: Когда-нибудь переделай это говно
  map["Давно отмеченные"] = taskItems
      .where((element) =>
          element.whenMarked != DateTime(1) &&
          DateFormat.MMMd().format(element.whenMarked) !=
              DateFormat.MMMd().format(DateTime.now()))
      .toList();
  map["Недавно отмеченные"] = taskItems
      .where((element) =>
          element.whenMarked != DateTime(1) &&
          DateFormat.MMMd().format(element.whenMarked) ==
              DateFormat.MMMd().format(DateTime.now()))
      .toList();
  map["Без пометки"] =
      taskItems.where((element) => element.whenMarked == DateTime(1)).toList();
  map.removeWhere((key, value) => value.isEmpty);
  return map;
}
