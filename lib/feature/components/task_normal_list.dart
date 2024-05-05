import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';

import 'app_task.dart';

class TaskNormalList extends StatefulWidget {
  const TaskNormalList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskNormalList> createState() => _TaskNormalListState();
}

class _TaskNormalListState extends State<TaskNormalList> {
  @override
  Widget build(BuildContext context) {
    List<TaskItem>? sortedList = widget.taskItems.toList();
    sortedList.sort((a, b) => b.position.compareTo(a.position));
    Iterable<TaskItem>? uncompleted =
        sortedList.where((element) => element.isCompleted == false);
    Iterable<TaskItem>? completed =
        sortedList.where((element) => element.isCompleted == true);

    return widget.taskItems.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: uncompleted.map((e) => AppTask(task: e)).toList(),
                  ),
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
            ),
          );
  }
}
