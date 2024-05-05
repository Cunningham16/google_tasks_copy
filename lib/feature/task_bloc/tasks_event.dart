part of "tasks_bloc.dart";

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class TaskSubscribtionRequested extends TaskEvent {
  const TaskSubscribtionRequested();
}

final class TaskCreated extends TaskEvent {
  const TaskCreated(this.companion);

  final TaskItemsCompanion companion;

  @override
  List<Object> get props => [companion];
}

final class TaskCompletionToggled extends TaskEvent {
  const TaskCompletionToggled(this.taskItem, this.isCompleted);

  final TaskItem taskItem;
  final bool isCompleted;

  @override
  List<Object> get props => [taskItem, isCompleted];
}

final class TaskUndoChanged extends TaskEvent {
  const TaskUndoChanged(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

final class TaskLastDumped extends TaskEvent {
  const TaskLastDumped();
}

final class TaskDeleted extends TaskEvent {
  const TaskDeleted(this.taskItem);

  final TaskItem taskItem;

  @override
  List<Object> get props => [taskItem];
}

final class TaskUpdated extends TaskEvent {
  const TaskUpdated(this.newTaskItem, this.index);

  final TaskItem newTaskItem;
  final int index;

  @override
  List<Object> get props => [index, newTaskItem];
}

final class TaskClearedAllCompleted extends TaskEvent {
  const TaskClearedAllCompleted(this.categoryId);

  final int categoryId;

  @override
  List<Object> get props => [categoryId];
}

final class TaskLastDeletedDump extends TaskEvent {
  const TaskLastDeletedDump();
}

final class TaskUpdatedCategory extends TaskEvent {
  const TaskUpdatedCategory(this.taskItem);

  final TaskItem taskItem;

  @override
  List<Object> get props => [taskItem];
}

final class TaskUpdatedCategoryUndo extends TaskEvent {
  const TaskUpdatedCategoryUndo();
}

final class TaskUpdatedCategoryDump extends TaskEvent {
  const TaskUpdatedCategoryDump();
}
