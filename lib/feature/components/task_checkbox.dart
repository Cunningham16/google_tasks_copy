import 'package:flutter/material.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (bool? value) {},
      shape: const CircleBorder(),
    );
  }
}
