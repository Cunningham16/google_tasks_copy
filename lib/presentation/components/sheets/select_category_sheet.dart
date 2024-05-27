import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/components/category_select_button.dart';

class SelectCategorySheet extends StatelessWidget {
  const SelectCategorySheet({super.key, required this.currentCategory});

  final int currentCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Куда отправить задачу?",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();
                    }
                    return CategorySelectButton(
                      onTap: () {
                        Navigator.of(context).pop(state.categoryList[index].id);
                      },
                      title: state.categoryList[index].name,
                      iconInfo: state.categoryList[index].id == currentCategory
                          ? Icons.done
                          : null,
                    );
                  }),
            ],
          ),
        ));
  }
}
