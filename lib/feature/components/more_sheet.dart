import 'package:flutter/material.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
                padding: const EdgeInsets.all(15),
                child: const Row(children: [Text("Переименовать список")])),
          ),
          InkWell(
            onTap: () {},
            child: Container(
                padding: const EdgeInsets.all(15),
                child: const Row(children: [Text("Удалить список")])),
          ),
          InkWell(
            onTap: () {},
            child: Container(
                padding: const EdgeInsets.all(15),
                child:
                    const Row(children: [Text("Удалить выполненные задачи")])),
          ),
        ],
      ),
    );
  }
}
