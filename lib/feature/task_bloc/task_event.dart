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
