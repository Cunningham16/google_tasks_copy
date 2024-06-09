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
  const CategoryCreated(this.params);

  final SaveCategoryParams params;

  @override
  List<Object> get props => [params];
}

final class CategoryUpdated extends CategoryEvent {
  const CategoryUpdated(this.params);

  final UpdateCategoryParams params;

  @override
  List<Object> get props => [params];
}

final class CategoryDeleted extends CategoryEvent {
  const CategoryDeleted(this.taskCategory);

  final TaskCategory taskCategory;

  @override
  List<Object> get props => [taskCategory];
}
