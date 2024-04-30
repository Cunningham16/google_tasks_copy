import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';

import 'app_task.dart';

class TaskNormalList extends StatelessWidget {
  const TaskNormalList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  Widget build(BuildContext context) {
    List<TaskItem>? sortedList = taskItems.toList();
    sortedList.sort((a, b) => b.position.compareTo(a.position));
    Iterable<TaskItem>? uncompleted =
        sortedList.where((element) => element.isCompleted == false);
    Iterable<TaskItem>? completed =
        sortedList.where((element) => element.isCompleted == true);

    return taskItems.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: uncompleted.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        color: Colors.transparent,
                        child: AppTask(
                          task: uncompleted.elementAt(index),
                        ),
                      );
                    },
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
