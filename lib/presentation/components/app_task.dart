import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/screens/screens.dart';

class AppTask extends StatelessWidget {
  const AppTask({
    super.key,
    required this.taskId,
    this.hideChip,
  });

  final int taskId;
  final bool? hideChip;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        TaskItem taskItem =
            state.taskList.firstWhere((element) => element.id == taskId);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go(TaskDetails.route);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: taskItem.isCompleted,
                    onChanged: (bool? value) {
                      context.read<TaskBloc>().add(TaskCompletionToggled(
                          taskItem, !taskItem.isCompleted));
                    },
                    shape: const CircleBorder(),
                  ),
                  const Gap(10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Gap(13),
                      Text(
                        taskItem.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                decoration: taskItem.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w400),
                      ),
                      const Gap(8),
                      if (taskItem.content.isNotEmpty)
                        SizedBox(
                          width: 100,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            taskItem.content.replaceAll("\n", " "),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      const Gap(5),
                      if (taskItem.date != DateTime(1) && hideChip == null)
                        Chip(
                            label: Text(
                          DateFormat.MMMd().format(taskItem.date),
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                    ],
                  )),
                  IconButton(
                      onPressed: () {
                        final dateFavorite =
                            !taskItem.isFavorite ? DateTime.now() : DateTime(1);
                        context.read<TaskBloc>().add(TaskUpdated(
                            taskItem.copyWith(
                                isFavorite: !taskItem.isFavorite,
                                whenMarked: dateFavorite),
                            taskItem.id));
                      },
                      icon: Icon(
                        taskItem.isFavorite
                            ? Icons.star
                            : Icons.star_border_outlined,
                        size: 25,
                        color: taskItem.isFavorite
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
