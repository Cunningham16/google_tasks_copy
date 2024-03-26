import 'package:flutter/material.dart';

import 'category_list_button.dart';

class CategoryListSheet extends StatelessWidget {
  const CategoryListSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const CategoryListButton(
            title: "Избранные",
            iconInfo: Icons.star,
          ),
          const Divider(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const CategoryListButton(
                  title: "some shit",
                  iconInfo: Icons.done,
                );
              }),
          const Divider(),
          const CategoryListButton(
            title: "Создать список",
            iconInfo: Icons.add,
          ),
        ],
      ),
    );
  }
}
