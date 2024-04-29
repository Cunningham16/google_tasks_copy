import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/screens/create_list.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet(
      {super.key, required this.snapshot, required this.tabController});

  final TasksWithCategories snapshot;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final newNameTab = await Navigator.of(context)
                      .push(CreateListScreen.route(snapshot.taskCategory.name))
                  as String;
              if (!context.mounted) return;
              RepositoryProvider.of<TaskRepository>(context).updateCategory(
                  snapshot.taskCategory.id,
                  snapshot.taskCategory
                      .copyWith(name: newNameTab)
                      .toCompanion(true));
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                child: const Row(children: [Text("Переименовать список")])),
          ),
          InkWell(
            onTap: () {
              if (snapshot.taskCategory.isDeletable) {
                tabController.animateTo(1);
                RepositoryProvider.of<TaskRepository>(context)
                    .deleteCategory(snapshot.taskCategory.id);
                Navigator.of(context).pop();
              }
            },
            highlightColor: snapshot.taskCategory.isDeletable
                ? Colors.black.withOpacity(0.09)
                : Colors.transparent,
            splashColor: snapshot.taskCategory.isDeletable
                ? Colors.black.withOpacity(0.09)
                : Colors.transparent,
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Text("Удалить список",
                      style: TextStyle(
                          color: !snapshot.taskCategory.isDeletable
                              ? Colors.black26
                              : Colors.black87))
                ])),
          ),
          InkWell(
            onTap: () {
              if (snapshot.taskItems
                  .where((element) => element.isCompleted)
                  .isNotEmpty) {
                RepositoryProvider.of<TaskRepository>(context)
                    .deleteAllCompletedTasks(snapshot.taskCategory.id);
                Navigator.of(context).pop();
              } else {
                null;
              }
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                child:
                    const Row(children: [Text("Удалить выполненные задачи")])),
          ),
        ],
      ),
    );
  }
}
