import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CreateListScreen(),
    );
  }

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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Создание списка"),
          actions: [
            TextButton(
                onPressed: text.isNotEmpty
                    ? () => Navigator.of(context).pop(text)
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
        ));
  }
}
