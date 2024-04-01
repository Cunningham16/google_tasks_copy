import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/data/entities/task.entity.dart';
import 'package:google_tasks/feature/components/task_checkbox.dart';

import '../routes/routes.dart';

class AppTask extends StatelessWidget {
  const AppTask({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go("/${RoutesLocation.taskDetails}"),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            TaskCheckbox(value: task.isCompleted),
            const Gap(10),
            Expanded(child: Text(task.title)),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  task.isFavorite == true
                      ? Icons.star
                      : Icons.star_border_outlined,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
