part of "category_bloc.dart";

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class CategorySubscriptionRequested extends CategoryEvent {
  const CategorySubscriptionRequested();
}

final class CategoryCreated extends CategoryEvent {
  const CategoryCreated(this.companion);

  final TaskCategoriesCompanion companion;

  @override
  List<Object> get props => [companion];
}

final class CategoryRenamed extends CategoryEvent {
  const CategoryRenamed(this.taskCategory, this.newName);

  final TaskCategory taskCategory;
  final String newName;

  @override
  List<Object> get props => [taskCategory, newName];
}

final class CategoryDeleted extends CategoryEvent {
  const CategoryDeleted(this.taskCategory);

  final TaskCategory taskCategory;

  @override
  List<Object> get props => [taskCategory];
}

final class CategoryChangedSort extends CategoryEvent {
  const CategoryChangedSort(this.taskCategory, this.sortType);

  final TaskCategory taskCategory;
  final SortTypes sortType;

  @override
  List<Object> get props => [taskCategory, sortType];
}
