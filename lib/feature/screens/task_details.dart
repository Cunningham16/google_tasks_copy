import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/feature/components/select_category_sheet.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key, required this.task});

  final TaskItem task;

  static Route<void> route(TaskItem taskItem) =>
      MaterialPageRoute<void>(builder: (_) => TaskDetails(task: taskItem));

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController contentTextController = TextEditingController();

  TaskItem? previousTaskState;

  @override
  void dispose() {
    titleTextController.dispose();
    contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        TaskItem taskItem = state.taskList
            .firstWhere((element) => element.id == widget.task.id);
        titleTextController.text = taskItem.title;
        contentTextController.text = taskItem.content;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (previousTaskState != null) {
                  context
                      .read<TaskBloc>()
                      .add(TaskUpdatedCategory(previousTaskState!));
                }
                Navigator.of(context).pop();
              },
            ),
            title: Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(TaskUpdated(
                          taskItem.copyWith(isFavorite: !taskItem.isFavorite),
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
                    )),
                PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                              onTap: () {
                                Navigator.of(context).pop();
                                context
                                    .read<TaskBloc>()
                                    .add(TaskDeleted(taskItem));
                              },
                              child: const SizedBox(
                                  width: 200, child: Text("Удалить задачу")))
                        ])
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: () async {
                  final TaskBloc bloc = context.read<TaskBloc>();
                  final int? selectedCategory = await _displayBottomSheet(
                      context,
                      SelectCategorySheet(
                        currentCategory: taskItem.category,
                      ));
                  if (selectedCategory != null) {
                    setState(() {
                      previousTaskState = taskItem;
                    });
                    bloc.add(TaskUpdated(
                        taskItem.copyWith(category: selectedCategory),
                        taskItem.id));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        context
                            .read<CategoryBloc>()
                            .state
                            .categoryList
                            .firstWhere(
                                (element) => element.id == taskItem.category)
                            .name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Gap(5),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ),
              TextField(
                minLines: 1,
                maxLines: 7,
                style: const TextStyle(fontSize: 24),
                controller: titleTextController,
                onChanged: (value) => context.read<TaskBloc>().add(
                    TaskUpdated(taskItem.copyWith(title: value), taskItem.id)),
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
                maxLines: 3,
                controller: contentTextController,
                onChanged: (value) => context.read<TaskBloc>().add(TaskUpdated(
                    taskItem.copyWith(content: value), taskItem.id)),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(Icons.format_align_left)),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
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
                      context.read<TaskBloc>().add(TaskUpdated(
                          taskItem.copyWith(date: value), taskItem.id));
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
                      taskItem.date != DateTime(1)
                          ? Chip(
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 15,
                              ),
                              label:
                                  Text(DateFormat.MMMd().format(taskItem.date)),
                              onDeleted: () {
                                context.read<TaskBloc>().add(TaskUpdated(
                                    taskItem.copyWith(date: DateTime(1)),
                                    taskItem.id));
                              },
                            )
                          : const Text("Добавить дату"),
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
                  context.read<TaskBloc>().add(
                      TaskCompletionToggled(taskItem, !taskItem.isCompleted));
                  Navigator.of(context).pop();
                },
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: taskItem.isCompleted
                        ? const Text("Задача выполнена")
                        : const Text("Задача не выполнена")),
              ),
            ),
          ),
        );
      },
    );
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
