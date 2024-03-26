import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/feature/components/task_checkbox.dart';

import '../routes/routes.dart';

class AppTask extends StatelessWidget {
  const AppTask(
      {super.key,
      required this.title,
      this.subtitle,
      required this.isCompleted,
      required this.isFavorite,
      this.time,
      this.date});

  final String title;
  final String? subtitle;
  final String? time;
  final String? date;
  final bool isCompleted;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go("/${RoutesLocation.taskDetails}"),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            TaskCheckbox(value: isCompleted),
            const Gap(10),
            Expanded(child: Text(title)),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  isFavorite == true ? Icons.star : Icons.star_border_outlined,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
