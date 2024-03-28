import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/data/entities/task.entity.dart';
import 'package:google_tasks/domain/task.repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskState()) {
    on<TaskSubscriptionRequested>(_onSubcriptionRequested);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskDeletionRequest>(_onTaskDeletionRequest);
    on<TaskUpdateRequest>(_onTaskUpdateRequest);
    on<TaskCreateRequest>(_onTaskCreateRequest);
  }

  final TaskRepository _taskRepository;

  Future<void> _onSubcriptionRequested(
      TaskSubscriptionRequested event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: () => TasksStatus.loading));

    await emit.forEach(_taskRepository.getAllTasks(),
        onData: (tasksList) => state.copyWith(
            status: () => TasksStatus.success, taskList: () => tasksList),
        onError: (_, __) => state.copyWith(
              status: () => TasksStatus.failure,
            ));
  }

  Future<void> _onTaskCompletionToggled(
      TaskCompletionToggled event, Emitter<TaskState> emit) async {
    final newTask = event.task.copyWith(isCompleted: event.isCompleted);
    await _taskRepository.updateTask(newTask.id, newTask);
  }

  Future<void> _onTaskDeletionRequest(
      TaskDeletionRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.deleteTask(event.id);
  }

  Future<void> _onTaskUpdateRequest(
      TaskUpdateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.updateTask(event.id, event.task);
  }

  Future<void> _onTaskCreateRequest(
      TaskCreateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.saveTask(event.task);
  }
}
