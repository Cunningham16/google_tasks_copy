import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

part "tasks_event.dart";
part "tasks_state.dart";

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(const TaskState()) {
    on<TaskSubscribtionRequested>(_onTaskSubcriptionRequested);
    on<TaskCreated>(_onTaskCreated);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskUndoChanged>(_onTaskUndoChanged);
    on<TaskLastDumped>(_onTaskLastDumped);
    on<TaskClearedAllCompleted>(_onTaskClearedAllCompleted);
    on<TaskLastDeletedDump>(_onTaskLastDeletedDumped);
    on<TaskUpdatedCategory>(_onTaskUpdatedCategory);
    on<TaskUpdatedCategoryUndo>(_onTaskUpdatedCategoryUndo);
    on<TaskUpdatedCategoryDump>(_onTaskUpdatedCategoryDump);
  }

  final TaskRepository _taskRepository;

  Future<void> _onTaskSubcriptionRequested(
      TaskSubscribtionRequested event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: () => TaskStatus.loading));

    await emit.forEach(_taskRepository.watchAllTasks(),
        onData: (data) => state.copyWith(
            status: () => TaskStatus.success, taskList: () => data));
  }

  Future<void> _onTaskCreated(
      TaskCreated event, Emitter<TaskState> emit) async {
    await _taskRepository.saveTask(event.companion);
  }

  Future<void> _onTaskDeleted(
      TaskDeleted event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastDeletedTask: () => event.taskItem));
    await _taskRepository.deleteTask(event.taskItem.id);
  }

  Future<void> _onTaskUpdated(
      TaskUpdated event, Emitter<TaskState> emit) async {
    await _taskRepository.updateTask(
        event.index, event.newTaskItem.toCompanion(true));
  }

  Future<void> _onTaskUndoChanged(
      TaskUndoChanged event, Emitter<TaskState> emit) async {
    await _taskRepository.updateTask(
        event.index, state.lastCompletedTask!.toCompanion(true));
    emit(state.copyWith(lastCompletedTask: () => null));
  }

  Future<void> _onTaskLastDumped(
      TaskLastDumped event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastCompletedTask: () => null));
  }

  Future<void> _onTaskCompletionToggled(
      TaskCompletionToggled event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastCompletedTask: () => event.taskItem));
    await _taskRepository.updateTask(
        event.taskItem.id,
        event.taskItem
            .copyWith(isCompleted: event.isCompleted)
            .toCompanion(true));
  }

  Future<void> _onTaskClearedAllCompleted(
      TaskClearedAllCompleted event, Emitter<TaskState> emit) async {
    await _taskRepository.deleteAllCompletedTasks(event.categoryId);
  }

  Future<void> _onTaskLastDeletedDumped(
      TaskLastDeletedDump event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastDeletedTask: () => null));
  }

  Future<void> _onTaskUpdatedCategory(
      TaskUpdatedCategory event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastUpdatedCategoryTask: () => event.taskItem));
  }

  Future<void> _onTaskUpdatedCategoryUndo(
      TaskUpdatedCategoryUndo event, Emitter<TaskState> emit) async {
    await _taskRepository.updateTask(state.lastUpdatedCategoryTask!.id,
        state.lastUpdatedCategoryTask!.toCompanion(true));
  }

  Future<void> _onTaskUpdatedCategoryDump(
      TaskUpdatedCategoryDump event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastUpdatedCategoryTask: () => null));
  }
}
