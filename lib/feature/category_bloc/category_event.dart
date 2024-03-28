part of 'category_bloc.dart';

class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryCreateRequest extends CategoryEvent {
  const CategoryCreateRequest(this.category);

  final CategoryEntity category;

  @override
  List<Object> get props => [category];
}

class CategoryDeleteRequest extends CategoryEvent {
  const CategoryDeleteRequest(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class CategorySubscribeRequest extends CategoryEvent {
  const CategorySubscribeRequest();
}

class CategoryUpdateRequest extends CategoryEvent {
  const CategoryUpdateRequest(this.id, this.categoryEntity);

  final int id;
  final CategoryEntity categoryEntity;

  @override
  List<Object> get props => [id, categoryEntity];
}
