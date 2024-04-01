import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/feature/task_bloc/task_bloc.dart';

import '../routes/routes.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  @override
  State<CreateListScreen> createState() => _CreateListState();
}

class _CreateListState extends State<CreateListScreen> {
  final controller = TextEditingController();
  String text = '';

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void setText(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.go(RoutesLocation.home),
            ),
            title: const Text("Создание списка"),
            actions: [
              TextButton(
                  onPressed: text.isNotEmpty
                      ? () {
                          BlocProvider.of<TaskBloc>(context).add(
                              CategoryCreateRequest(
                                  CategoryEntity(name: text)));
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text("Готово"))
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Введите название списка",
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                onChanged: (text) => setText(text),
              ),
            ),
          )),
    );
  }
}
