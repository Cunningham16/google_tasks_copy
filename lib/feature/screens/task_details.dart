import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/components/select_category_sheet.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key, required this.taskId});

  final int taskId;

  static Route<void> route(int taskId) =>
      MaterialPageRoute<void>(builder: (_) => TaskDetails(taskId: taskId));

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController contentTextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskItem>(
        stream: RepositoryProvider.of<TaskRepository>(context)
            .watchSingleTask(widget.taskId),
        builder: (context, task) {
          titleTextController.text = task.data!.title;
          if (task.data?.content != null) {
            contentTextController.text = task.data!.content;
          }
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        RepositoryProvider.of<TaskRepository>(context)
                            .updateTask(
                                widget.taskId,
                                task.data!
                                    .copyWith(
                                        isFavorite: !task.data!.isFavorite)
                                    .toCompanion(true));
                      },
                      icon: task.data!.isFavorite
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined)),
                  PopupMenuButton(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  RepositoryProvider.of<TaskRepository>(context)
                                      .deleteTask(widget.taskId);
                                },
                                child: const SizedBox(
                                    width: 200, child: Text("Удалить задачу")))
                          ])
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _displayBottomSheet(
                            context,
                            SelectCategorySheet(
                              taskItem: task.data!,
                            ));
                      },
                      child: FutureBuilder<TaskCategory>(
                          future: RepositoryProvider.of<TaskRepository>(context)
                              .getCategoryById(task.data!.category),
                          builder: (context, category) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(category.data!.name),
                                  const Icon(Icons.arrow_drop_down, size: 20)
                                ],
                              ),
                            );
                          }),
                    ),
                    TextField(
                      minLines: 1,
                      maxLines: 7,
                      style: const TextStyle(fontSize: 24),
                      controller: titleTextController,
                      onChanged: (value) =>
                          RepositoryProvider.of<TaskRepository>(context)
                              .updateTask(
                                  widget.taskId,
                                  task.data!
                                      .copyWith(title: value)
                                      .toCompanion(true)),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          border: InputBorder.none,
                          labelText: "Введите название",
                          alignLabelWithHint: false,
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    ),
                    const Gap(20),
                    TextField(
                      minLines: 1,
                      maxLines: 7,
                      onChanged: (value) =>
                          RepositoryProvider.of<TaskRepository>(context)
                              .updateTask(
                                  widget.taskId,
                                  task.data!
                                      .copyWith(content: value)
                                      .toCompanion(true)),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: Icon(Icons.format_align_left)),
                          border: InputBorder.none,
                          labelText: "Добавьте подзаголовок",
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    ),
                    const Gap(15),
                    InkWell(
                      onTap: () async {
                        await showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(2030))
                            .then((value) {
                          if (value != null) {
                            RepositoryProvider.of<TaskRepository>(context)
                                .updateTask(
                                    widget.taskId,
                                    task.data!
                                        .copyWith(date: Value(value))
                                        .toCompanion(true));
                          }
                        });
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Gap(2),
                            const Icon(Icons.event),
                            const Gap(12.5),
                            task.data!.date != null
                                ? Chip(
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                    label: Text(DateFormat.MMMd()
                                        .format(task.data!.date!)),
                                    onDeleted: () {
                                      RepositoryProvider.of<TaskRepository>(
                                              context)
                                          .updateTask(
                                              widget.taskId,
                                              task.data!
                                                  .copyWith(
                                                      date: const Value(null))
                                                  .toCompanion(false));
                                    },
                                  )
                                : const Text("Добавить дату")
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    RepositoryProvider.of<TaskRepository>(context).updateTask(
                        widget.taskId,
                        task.data!
                            .copyWith(isCompleted: !task.data!.isCompleted)
                            .toCompanion(true));
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: task.data!.isCompleted
                          ? const Text("Задача выполнена")
                          : const Text("Задача не выполнена")),
                ),
              ),
            ),
          );
        });
  }
}

Future _displayBottomSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(children: [child]);
      });
}
