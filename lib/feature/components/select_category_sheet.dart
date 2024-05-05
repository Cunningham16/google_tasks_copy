import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/components/category_list_button.dart';

class SelectCategorySheet extends StatelessWidget {
  const SelectCategorySheet({super.key, required this.currentCategory});

  final int currentCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) => ListView.builder(
              shrinkWrap: true,
              itemCount: state.categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container();
                }
                return CategoryListButton(
                  onTap: () {
                    Navigator.of(context).pop(state.categoryList[index].id);
                  },
                  title: state.categoryList[index].name,
                  iconInfo: state.categoryList[index].id == currentCategory
                      ? Icons.done
                      : null,
                );
              }),
        ));
  }
}
