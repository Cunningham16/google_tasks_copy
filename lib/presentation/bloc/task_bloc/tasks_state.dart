part of "tasks_bloc.dart";

enum TaskStatus { initial, loading, success, failure }

final class TaskState extends Equatable {
  const TaskState(
      {this.status = TaskStatus.initial,
      this.taskList = const [],
      this.lastCompletedTask,
      this.lastDeletedTask,
      this.lastUpdatedCategoryTask});

  final TaskStatus status;
  final List<TaskItem> taskList;
  final TaskItem? lastCompletedTask;
  final TaskItem? lastDeletedTask;
  final TaskItem? lastUpdatedCategoryTask;

  TaskState copyWith(
      {TaskStatus Function()? status,
      List<TaskItem> Function()? taskList,
      TaskItem? Function()? lastCompletedTask,
      TaskItem? Function()? lastDeletedTask,
      TaskItem? Function()? lastUpdatedCategoryTask}) {
    return TaskState(
        status: status != null ? status() : this.status,
        taskList: taskList != null ? taskList() : this.taskList,
        lastCompletedTask: lastCompletedTask != null
            ? lastCompletedTask()
            : this.lastCompletedTask,
        lastDeletedTask:
            lastDeletedTask != null ? lastDeletedTask() : this.lastDeletedTask,
        lastUpdatedCategoryTask: lastUpdatedCategoryTask != null
            ? lastUpdatedCategoryTask()
            : this.lastUpdatedCategoryTask);
  }

  @override
  List<Object?> get props => [
        status,
        taskList,
        lastCompletedTask,
        lastDeletedTask,
        lastUpdatedCategoryTask
      ];
}
