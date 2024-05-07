import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';

import 'app_task.dart';

class TaskNormalList extends StatefulWidget {
  const TaskNormalList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskNormalList> createState() => _TaskNormalListState();
}

class _TaskNormalListState extends State<TaskNormalList> {
  bool isStateChangingFast = false;
  List<TaskItem> uncompleted = [];

  @override
  void initState() {
    setState(() {
      uncompleted =
          widget.taskItems.where((element) => !element.isCompleted).toList();
      uncompleted.sort(
        (a, b) => a.position.compareTo(b.position),
      );
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskNormalList oldWidget) {
    if (!isStateChangingFast) {
      setState(() {
        uncompleted =
            widget.taskItems.where((element) => !element.isCompleted).toList();
        uncompleted.sort(
          (a, b) => a.position.compareTo(b.position),
        );
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<TaskItem> sortedList = widget.taskItems.toList();
    List<TaskItem>? completed =
        sortedList.where((element) => element.isCompleted == true).toList();

    return sortedList.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: uncompleted.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      TaskBloc taskBloc = context.read<TaskBloc>();

                      setState(() {
                        TaskItem item = uncompleted.removeAt(oldIndex);
                        uncompleted.insert(newIndex, item);
                      });

                      for (int i = 0; i < uncompleted.length; i++) {
                        if (i == 0) {
                          setState(() {
                            isStateChangingFast = true;
                          });
                        }
                        taskBloc.add(TaskUpdated(
                            uncompleted.toList()[i].copyWith(position: i),
                            uncompleted.toList()[i].id));
                        if (i == uncompleted.length - 1) {
                          setState(() {
                            isStateChangingFast = false;
                          });
                        }
                      }
                    },
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) =>
                        ReorderableDragStartListener(
                          key: Key("${uncompleted.toList()[index].id}"),
                          index: index,
                          child: AppTask(
                            task: uncompleted.toList()[index],
                            key: Key("${uncompleted.toList()[index].id}"),
                          ),
                        )),
                if (completed.isNotEmpty)
                  Column(
                    children: [
                      const Divider(
                        height: 0,
                        thickness: 1,
                      ),
                      CompletedTasksList(
                          taskItems:
                              completed.where((element) => element.isCompleted))
                    ],
                  )
              ],
            ),
          );
  }
}
