import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.star_border_outlined)),
            PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                          child: SizedBox(
                              width: 200, child: Text("Удалить задачу")))
                    ])
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Сегодня"),
                  Icon(Icons.arrow_drop_down, size: 20)
                ],
              ),
            ),
          ),
          TextField(
            minLines: 1,
            maxLines: 7,
            style: const TextStyle(fontSize: 24),
            controller: TextEditingController(text: "Я еблаэто в рот"),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                border: InputBorder.none,
                labelText: "Введите название",
                alignLabelWithHint: false,
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
          const Gap(20),
          const TextField(
            minLines: 1,
            maxLines: 7,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                prefixIcon: Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Icon(Icons.format_align_left)),
                border: InputBorder.none,
                labelText: "Добавьте подзаголовок",
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
          const Gap(15),
          //TODO: переделать нахуй при необходимости
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Gap(2),
                  Icon(Icons.event),
                  Gap(12.5),
                  Text("Добавить дату")
                ],
              ),
            ),
          ),
          const Gap(15),
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Gap(2),
                  Icon(Icons.schedule),
                  Gap(12.5),
                  Text("Добавить время")
                ],
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {},
            child: const Padding(
                padding: EdgeInsets.all(15), child: Text("Задача выполнена")),
          ),
        ),
      ),
    );
  }
}
