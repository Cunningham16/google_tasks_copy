import 'package:flutter/material.dart';

import 'app_task.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(5),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return const Material(
          color: Colors.transparent,
          child: AppTask(
              title: "Go fuck yourself", isCompleted: false, isFavorite: true),
        );
      },
    );
  }
}
