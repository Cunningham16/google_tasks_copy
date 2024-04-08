import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';

import 'app_task.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.filteredList});

  final Iterable<TaskItem>? filteredList;

  @override
  Widget build(BuildContext context) {
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