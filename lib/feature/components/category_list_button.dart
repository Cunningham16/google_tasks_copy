import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryListButton extends StatelessWidget {
  const CategoryListButton(
      {super.key, required this.title, required this.iconInfo});

  final String title;
  final IconData iconInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [Icon(iconInfo, size: 25), const Gap(10), Text(title)],
        ),
      ),
    );
  }
}
