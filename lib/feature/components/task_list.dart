import 'package:flutter/material.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/components/completed_tasks_list.dart';

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
    Iterable<TaskItem>? uncompleted =
        filteredList?.where((element) => element.isCompleted == false);
    Iterable<TaskItem>? completed =
        filteredList?.where((element) => element.isCompleted == true);
    return filteredList != null && filteredList!.isEmpty
        ? const Center(child: Text('No tasks yet'))
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: uncompleted?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: Colors.transparent,
                      child: AppTask(
                        task: uncompleted!.elementAt(index),
                      ),
                    );
                  },
                ),
                if (completed!.isNotEmpty)
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
