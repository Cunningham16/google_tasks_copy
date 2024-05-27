part of "category_bloc.dart";

enum CategoryStatus { initial, loading, success, failure }

final class CategoryState extends Equatable {
  const CategoryState(
      {this.categoryList = const [],
      this.categoryStatus = CategoryStatus.initial});

  final CategoryStatus categoryStatus;
  final List<TaskCategory> categoryList;

  CategoryState copyWith(
      {List<TaskCategory> Function()? categoryList,
      CategoryStatus Function()? categoryStatus}) {
    return CategoryState(
        categoryStatus:
            categoryStatus != null ? categoryStatus() : this.categoryStatus,
        categoryList:
            categoryList != null ? categoryList() : this.categoryList);
  }

  @override
  List<Object?> get props => [categoryList, categoryStatus];
}
