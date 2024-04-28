import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';

import 'app_task.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {super.key, required this.filteredList, required this.sortType});

  final Iterable<TaskItem>? filteredList;
  final int sortType;

  @override
  Widget build(BuildContext context) {
    List<TaskItem>? sortedList;
    if (sortType == 0) {
      sortedList = filteredList!.toList();
      sortedList.sort((a, b) => a.position.compareTo(b.position));
    }
    return filteredList != null && filteredList!.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(5),
            itemCount: filteredList?.length,
            itemBuilder: (BuildContext context, int index) {
              return Material(
                color: Colors.transparent,
                child: AppTask(
                  task: filteredList!.elementAt(index),
                ),
              );
            },
          );
  }
}
