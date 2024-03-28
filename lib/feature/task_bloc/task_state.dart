part of 'task_bloc.dart';

enum TasksStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  const TaskState(
      {this.taskList = const [], this.status = TasksStatus.initial});

  final List<TaskEntity> taskList;
  final TasksStatus status;

  TaskState copyWith(
      {List<TaskEntity> Function()? taskList, TasksStatus Function()? status}) {
    return TaskState(
        taskList: taskList != null ? taskList() : this.taskList,
        status: status != null ? status() : this.status);
  }

  @override
  List<Object> get props => [taskList, status];
}
