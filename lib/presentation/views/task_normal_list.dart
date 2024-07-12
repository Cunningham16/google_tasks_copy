import "dart:developer";

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/presentation/views/completed_tasks_list.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';

import '../components/app_task.dart';

class TaskNormalList extends StatefulWidget {
  const TaskNormalList({super.key, required this.taskItems});

  final Iterable<TaskItem> taskItems;

  @override
  State<TaskNormalList> createState() => _TaskNormalListState();
}

class _TaskNormalListState extends State<TaskNormalList> {
  bool isStateChanging = false;
  List<TaskItem> uncompletedList = [];

  @override
  void initState() {
    setState(
      () {
        uncompletedList =
            widget.taskItems.where((element) => !element.isCompleted).toList();
        uncompletedList.sort((a, b) => a.position.compareTo(b.position));
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskNormalList oldWidget) {
    if (!isStateChanging) {
      setState(() {
        uncompletedList =
            widget.taskItems.where((element) => !element.isCompleted).toList();
        uncompletedList.sort((a, b) => a.position.compareTo(b.position));
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void reorderUnompletedTasks(int oldIndex, int newIndex) {
    final TaskBloc taskBloc = context.read<TaskBloc>();

    if (oldIndex < newIndex) {
      newIndex--;
    }

    print(oldIndex);
    print(newIndex);

    log("hello there");

    setState(() {
      isStateChanging = true;
      final item = uncompletedList.removeAt(oldIndex);
      uncompletedList.insert(newIndex, item);
    });

    taskBloc.add(ReorderTaskPosition(
        uncompletedList[oldIndex].category, uncompletedList));

    setState(() {
      isStateChanging = false;
    });
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
                    shrinkWrap: true,
                    itemCount: uncompletedList.length,
                    onReorder: (int oldIndex, int newIndex) =>
                        reorderUnompletedTasks(oldIndex, newIndex),
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) =>
                        ReorderableDragStartListener(
                          index: index,
                          key: Key(uncompletedList[index].id),
                          child: AppTask(
                            taskId: uncompletedList[index].id,
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
