import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<TaskItem> sortedList = [];
  List<TaskItem> uncompleted = [];

  @override
  void initState() {
    setState(() {
      sortedList = widget.taskItems.toList();
    });
    setState(() {
      uncompleted =
          sortedList.where((element) => element.isCompleted == false).toList();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskNormalList oldWidget) {
    setState(() {
      sortedList = widget.taskItems.toList();
    });
    List<TaskItem> uncompletedRaw =
        sortedList.where((element) => element.isCompleted == false).toList();
    uncompletedRaw.sort((a, b) => b.position.compareTo(a.position));
    if (uncompletedRaw == uncompleted &&
        uncompletedRaw.length == uncompleted.length) {
      setState(() {
        uncompleted = uncompletedRaw;
      });
    } else if (uncompletedRaw != uncompleted &&
        uncompletedRaw.length != uncompleted.length) {
      setState(() {
        uncompleted = uncompletedRaw;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
                        taskBloc.add(TaskUpdated(
                            uncompleted
                                .toList()[i]
                                .copyWith(position: uncompleted.length - i),
                            uncompleted.toList()[i].id));
                      }
                    },
                    itemBuilder: (context, index) => AppTask(
                          task: uncompleted.toList()[index],
                          key: Key("${uncompleted.toList()[index].id}"),
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
