import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/service_locator.dart';
import 'package:intl/intl.dart';

import '../sheets/sheets.dart';

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
  String? content;
  DateTime? date;
  bool isFavorite = false;
  String category = '';

  bool isContentVisible = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      category = context
          .read<CategoryBloc>()
          .state
          .categoryList[
              serviceLocator<SharedPreferencesRepository>().getLastTab() as int]
          .id;
    });
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
          if (widget.isFavoriteFlag)
            InkWell(
              onTap: () async {
                final String? selectedCategory = await _displayBottomSheet(
                    context,
                    SelectCategorySheet(
                      currentCategory: category,
                    ));
                if (selectedCategory != null) {
                  setState(() {
                    category = selectedCategory;
                  });
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
                            .firstWhere((element) => element.id == category)
                            .name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
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
            controller: controllerTitle,
            onChanged: (text) {
              String correctedText = text.trim();
              setTextTitle(correctedText);
            },
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
              onChanged: (text) => setTextContent(text.trim()),
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
                  icon: Icon(
                    isFavorite || widget.isFavoriteFlag
                        ? Icons.star
                        : Icons.star_border_outlined,
                    size: 25,
                    color: isFavorite || widget.isFavoriteFlag
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  )),
              const Spacer(),
              TextButton(
                  onPressed: title != ""
                      ? () {
                          context.read<TaskBloc>().add(TaskCreated(
                              SaveTaskParams(
                                  title: title,
                                  content: content,
                                  isCompleted: false,
                                  isFavorite:
                                      widget.isFavoriteFlag ? true : isFavorite,
                                  date: date,
                                  whenMarked:
                                      widget.isFavoriteFlag || isFavorite
                                          ? DateTime.now()
                                          : null,
                                  category: widget.isFavoriteFlag
                                      ? context
                                          .read<CategoryBloc>()
                                          .state
                                          .categoryList[1]
                                          .id
                                      : category,
                                  position: widget.taskCount)));
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("Сохранить"))
            ],
          )
        ],
      ),
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
