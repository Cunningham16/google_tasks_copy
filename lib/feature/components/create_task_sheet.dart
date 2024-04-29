import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/cubit/home_page_cubit.dart';
import 'package:intl/intl.dart';

class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet(
      {super.key, required this.isFavoriteFlag, required this.taskCount});

  final bool isFavoriteFlag;
  final int taskCount;

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final controllerTitle = TextEditingController();
  final controllerContent = TextEditingController();

  late FocusNode contentFocusNode;

  String title = '';
  String content = '';
  DateTime? date;
  bool isFavorite = false;

  bool isContentVisible = false;

  @override
  void initState() {
    super.initState();
    contentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    controllerContent.dispose();
    controllerTitle.dispose();
    contentFocusNode.dispose();
    super.dispose();
  }

  void setTextTitle(String title) {
    setState(() {
      this.title = title;
    });
  }

  void setTextContent(String content) {
    setState(() {
      this.content = content;
    });
  }

  void toggleIsFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleContentVisibility() {
    setState(() {
      isContentVisible = !isContentVisible;
    });
    if (isContentVisible) {
      contentFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentTabCubit, int>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controllerTitle,
                onChanged: (text) => setTextTitle(text),
                autofocus: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    border: InputBorder.none,
                    hintText: "Новая задача",
                    floatingLabelBehavior: FloatingLabelBehavior.never),
              ),
              if (isContentVisible) ...[
                TextField(
                  controller: controllerContent,
                  onChanged: (text) => setTextContent(text),
                  focusNode: contentFocusNode,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      border: InputBorder.none,
                      hintText: "Добавьте дополнительную информацию",
                      floatingLabelBehavior: FloatingLabelBehavior.never),
                )
              ],
              Row(
                children: [
                  if (date != null)
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Chip(
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 15,
                          ),
                          label: Text(DateFormat.MMMd().format(date!)),
                          onDeleted: () {
                            setState(() {
                              date = null;
                            });
                          },
                        )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        !isContentVisible ? toggleContentVisibility() : null;
                      },
                      icon: const Icon(Icons.format_align_left)),
                  IconButton(
                      onPressed: () async {
                        await showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(2030))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              date = value;
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.event)),
                  IconButton(
                      onPressed: () {
                        toggleIsFavorite();
                      },
                      icon: isFavorite || widget.isFavoriteFlag
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined)),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        if (title.isNotEmpty) {
                          RepositoryProvider.of<TaskRepository>(context)
                              .saveTask(TaskItemsCompanion(
                                  title: Value(title),
                                  content: Value(content),
                                  category: Value(
                                      context.read<CurrentTabCubit>().state),
                                  isCompleted: const Value(false),
                                  isFavorite: Value(isFavorite),
                                  date: Value(date),
                                  position: Value(widget.taskCount)));
                          Navigator.of(context).pop();
                        } else {
                          null;
                        }
                      },
                      child: const Text("Сохранить"))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
