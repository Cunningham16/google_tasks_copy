import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';

class AppTask extends StatelessWidget {
  const AppTask({super.key, required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: () => context.go("/${RoutesLocation.taskDetails}"),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                RepositoryProvider.of<TaskRepository>(context).updateTask(
                    task.id,
                    task
                        .copyWith(isCompleted: !task.isCompleted)
                        .toCompanion(true));
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
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.w400),
                ),
                const Gap(8),
                if (task.content.isNotEmpty)
                  Text(
                    task.content,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const Gap(5),
                Row(
                  children: [
                    if (task.date.isNotEmpty)
                      Chip(
                          label: Text(
                        task.date,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                    const Gap(10),
                    if (task.time.isNotEmpty)
                      Chip(
                          label: Text(
                        task.time,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                  ],
                ),
              ],
            )),
            IconButton(
                onPressed: () {
                  RepositoryProvider.of<TaskRepository>(context).updateTask(
                      task.id,
                      task
                          .copyWith(isFavorite: !task.isFavorite)
                          .toCompanion(true));
                },
                icon: Icon(
                  task.isFavorite ? Icons.star : Icons.star_border_outlined,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
