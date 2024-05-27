import 'package:flutter/material.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key, this.name});

  final String? name;

  static Route<void> route(String? name) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateListScreen(
        name: name,
      ),
    );
  }

  @override
  State<CreateListScreen> createState() => _CreateListState();
}

class _CreateListState extends State<CreateListScreen> {
  final controller = TextEditingController();
  String text = '';

  @override
  void initState() {
    if (widget.name != null) {
      setState(() {
        text = widget.name as String;
      });
      controller.text = widget.name as String;
    }
    super.initState();
  }

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
          title: widget.name != ""
              ? Text(
                  "Переименование списка",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                )
              : Text(
                  "Создание списка",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
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
