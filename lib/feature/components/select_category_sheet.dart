import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/components/category_list_button.dart';

class SelectCategorySheet extends StatelessWidget {
  const SelectCategorySheet({super.key, required this.taskItem});

  final TaskItem taskItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<List<TaskCategory>>(
          stream:
              RepositoryProvider.of<TaskRepository>(context).watchCategories(),
          builder: (context, snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container();
                  }
                  return CategoryListButton(
                    onTap: () {
                      RepositoryProvider.of<TaskRepository>(context).updateTask(
                          taskItem.id,
                          taskItem
                              .copyWith(category: snapshot.data![index].id)
                              .toCompanion(true));
                      Navigator.of(context).pop();
                    },
                    title: snapshot.data![index].name,
                    iconInfo: snapshot.data![index].id == taskItem.category
                        ? Icons.done
                        : null,
                  );
                });
          }),
    );
  }
}
