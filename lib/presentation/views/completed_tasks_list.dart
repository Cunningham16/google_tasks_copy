import 'package:flutter/material.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/presentation/components/app_task.dart';

class CompletedTasksList extends StatefulWidget {
  const CompletedTasksList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<CompletedTasksList> createState() => _CompletedTasksListState();
}

class _CompletedTasksListState extends State<CompletedTasksList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 0,
          thickness: 1,
        ),
        ExpansionTile(
            tilePadding:
                const EdgeInsets.only(right: 18, left: 18, top: 0, bottom: 0),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            title: const Text("Выполненные"),
            children: widget.taskItems
                .map((task) => AppTask(
                      taskId: task.id,
                      hideChip: true,
                    ))
                .toList())
      ],
    );
  }
}
