import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';
import 'package:intl/intl.dart';

import 'app_task.dart';

class TaskDateList extends StatefulWidget {
  const TaskDateList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskDateList> createState() => _TaskDateListState();
}

class _TaskDateListState extends State<TaskDateList> {
  @override
  Widget build(BuildContext context) {
    Iterable<TaskItem> uncompleted =
        widget.taskItems.where((element) => element.isCompleted == false);
    Iterable<TaskItem> completed =
        widget.taskItems.where((element) => element.isCompleted == true);
    var sort = uncompleted.toList();
    sort.sort((a, b) {
      if (a.date == DateTime(1)) {
        return 1;
      }
      if (b.date == DateTime(1)) {
        return 1;
      }
      return a.date.compareTo(b.date);
    });
    var list = sort.toList().map((element) => element.date).toList();
    Map<String, List<TaskItem>> map = {};
    for (int i = 0; i < list.length; i++) {
      if (list[i] == DateTime(1)) {
        map["Без даты"] =
            sort.where((element) => element.date == DateTime(1)).toList();
      } else {
        map[DateFormat.MMMd().format(list[i])] = sort
            .where((element) =>
                element.date != DateTime(1) &&
                DateFormat.MMMd().format(element.date) ==
                    DateFormat.MMMd().format(list[i]))
            .toList();
      }
    }
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
                          children: map
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
                                        ..addAll(value.map((e) => AppTask(
                                              task: e,
                                              hideChip: true,
                                            ))))))
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
