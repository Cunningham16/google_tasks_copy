import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/routes.dart';

class CreateListScreen extends StatelessWidget {
  const CreateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go(RoutesLocation.home),
          ),
          title: const Text("Создание списка"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Готово"))
          ],
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Введите название списка",
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
        ));
  }
}
