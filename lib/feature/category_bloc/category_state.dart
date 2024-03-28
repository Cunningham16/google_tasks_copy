part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  const CategoryState(
      {this.categoryList = const [], this.status = CategoryStatus.initial});

  final List<CategoryEntity> categoryList;
  final CategoryStatus status;

  CategoryState copyWith(
      {List<CategoryEntity> Function()? categoryList,
      CategoryStatus Function()? status}) {
    return CategoryState(
        status: status != null ? status() : this.status,
        categoryList:
            categoryList != null ? categoryList() : this.categoryList);
  }

  @override
  List<Object> get props => [categoryList];
}
