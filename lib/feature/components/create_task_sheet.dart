import 'package:flutter/material.dart';

class CreateTaskSheet extends StatelessWidget {
  const CreateTaskSheet({super.key});

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
        children: [
          const TextField(
            autofocus: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                border: InputBorder.none,
                labelText: "Новая задача",
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.format_align_left)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.event)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.schedule)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_border_outlined)),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text("Сохранить"))
            ],
          )
        ],
      ),
    );
  }
}
