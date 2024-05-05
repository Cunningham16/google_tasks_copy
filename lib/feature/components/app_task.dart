import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/feature/screens/task_details.dart';
import 'package:intl/intl.dart';

class AppTask extends StatefulWidget {
  const AppTask(
      {super.key, required this.task, this.hideChip, this.onChangedCompletion});

  final TaskItem task;
  final bool? hideChip;
  final ValueChanged<bool>? onChangedCompletion;

  @override
  State<AppTask> createState() => _AppTaskState();
}

class _AppTaskState extends State<AppTask> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(TaskDetails.route(widget.task));
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: widget.task.isCompleted,
                  onChanged: (bool? value) {
                    context.read<TaskBloc>().add(TaskCompletionToggled(
                        widget.task, !widget.task.isCompleted));
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
                      widget.task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: widget.task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.w400),
                    ),
                    const Gap(8),
                    if (widget.task.content.isNotEmpty)
                      Text(
                        widget.task.content,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const Gap(5),
                    Row(
                      children: [
                        if (widget.task.date != DateTime(1) &&
                            widget.hideChip == null)
                          Chip(
                              label: Text(
                            DateFormat.MMMd().format(widget.task.date),
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      ],
                    ),
                  ],
                )),
                IconButton(
                    onPressed: () {
                      final dateFavorite = !widget.task.isFavorite
                          ? DateTime.now()
                          : DateTime(1);
                      context.read<TaskBloc>().add(TaskUpdated(
                          widget.task.copyWith(
                              isFavorite: !widget.task.isFavorite,
                              whenMarked: dateFavorite),
                          widget.task.id));
                    },
                    icon: Icon(
                      widget.task.isFavorite
                          ? Icons.star
                          : Icons.star_border_outlined,
                      size: 20,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
