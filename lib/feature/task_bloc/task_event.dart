part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class TaskSubscriptionRequested extends TaskEvent {
  const TaskSubscriptionRequested();
}

final class TaskCompletionToggled extends TaskEvent {
  const TaskCompletionToggled(this.task, this.isCompleted);

  final TaskEntity task;
  final bool isCompleted;

  @override
  List<Object> get props => [task, isCompleted];
}

// это для более универсального использования, возможно позже надо будет поменять что-то
final class TaskUpdateRequest extends TaskEvent {
  const TaskUpdateRequest(this.id, this.task);

  final int id;
  final TaskEntity task;

  @override
  List<Object> get props => [id, task];
}

final class TaskDeletionRequest extends TaskEvent {
  const TaskDeletionRequest(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

final class TaskCreateRequest extends TaskEvent {
  const TaskCreateRequest(this.task);

  final TaskEntity task;

  @override
  List<Object> get props => [task];
}

class CategoryCreateRequest extends TaskEvent {
  const CategoryCreateRequest(this.category);

  final CategoryEntity category;

  @override
  List<Object> get props => [category];
}

class CategoryDeleteRequest extends TaskEvent {
  const CategoryDeleteRequest(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class CategorySubscribeRequest extends TaskEvent {
  const CategorySubscribeRequest();
}

class CategoryUpdateRequest extends TaskEvent {
  const CategoryUpdateRequest(this.id, this.categoryEntity);

  final int id;
  final CategoryEntity categoryEntity;

  @override
  List<Object> get props => [id, categoryEntity];
}

class CategoryGetRequest extends TaskEvent {
  const CategoryGetRequest();
}
