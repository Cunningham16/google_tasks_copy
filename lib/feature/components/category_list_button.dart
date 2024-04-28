import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryListButton extends StatelessWidget {
  const CategoryListButton(
      {super.key, required this.title, this.iconInfo, required this.onTap});

  final String title;
  final IconData? iconInfo;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            iconInfo != null ? Icon(iconInfo, size: 25) : const Gap(25),
            const Gap(10),
            Text(title)
          ],
        ),
      ),
    );
  }
}
