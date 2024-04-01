part of 'task_bloc.dart';

enum TasksStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  const TaskState(
      {this.categoryList = const [],
      this.taskList = const [],
      this.status = TasksStatus.initial});

  final List<TaskEntity> taskList;
  final List<CategoryEntity> categoryList;
  final TasksStatus status;

  TaskState copyWith(
      {List<CategoryEntity> Function()? categoryList,
      List<TaskEntity> Function()? taskList,
      TasksStatus Function()? status}) {
    return TaskState(
        categoryList: categoryList != null ? categoryList() : this.categoryList,
        taskList: taskList != null ? taskList() : this.taskList,
        status: status != null ? status() : this.status);
  }

  @override
  List<Object> get props => [taskList, status];
}
