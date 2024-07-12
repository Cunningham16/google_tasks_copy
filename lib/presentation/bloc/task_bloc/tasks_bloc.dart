import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_completed_use_case.dart';
import 'package:google_tasks/domain/use_cases/get_single_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/reorder_task_list_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/update_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/watch_all_tasks_use_case.dart';

part "tasks_event.dart";
part "tasks_state.dart";

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final SaveTaskUseCase saveTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final WatchAllTasksUseCase watchAllTasksUseCase;
  final GetSingleTaskUseCase getSingleTaskUseCase;
  final DeleteTasksByCategoryUseCase deleteTasksByCategoryUseCase;
  final DeleteTasksByCompletedUseCase deleteTasksByCompletedUseCase;
  final ReorderTaskListUseCase reorderTaskListUseCase;

  TaskBloc(
      {required this.saveTaskUseCase,
      required this.deleteTaskUseCase,
      required this.updateTaskUseCase,
      required this.watchAllTasksUseCase,
      required this.getSingleTaskUseCase,
      required this.deleteTasksByCategoryUseCase,
      required this.deleteTasksByCompletedUseCase,
      required this.reorderTaskListUseCase})
      : super(const TaskState()) {
    on<TaskSubscribtionRequested>(_onTaskSubcriptionRequested);
    on<TaskCreated>(_onTaskCreated);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskUndoChanged>(_onTaskUndoChanged);
    on<TaskLastDumped>(_onTaskLastDumped);
    on<TaskClearedAllCompleted>(_onTaskClearedAllCompleted);
    on<TaskLastDeletedDump>(_onTaskLastDeletedDumped);
    on<TaskUpdatedCategory>(_onTaskUpdatedCategory);
    on<TaskUpdatedCategoryUndo>(_onTaskUpdatedCategoryUndo);
    on<TaskUpdatedCategoryDump>(_onTaskUpdatedCategoryDump);
    on<TasksDeletedByCategory>(_onTasksDeletedByCategory);
    on<GetSingleTask>(_onGetSingleTask);
    on<ReorderTaskPosition>(_onReorderTaskPosition);
    on<TaskCompleted>(_onTaskCompleted);
  }

  Future<void> _onTaskSubcriptionRequested(
      TaskSubscribtionRequested event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: () => TaskStatus.loading));

    await emit.forEach(watchAllTasksUseCase(),
        onData: (data) => state.copyWith(
            status: () => TaskStatus.success, taskList: () => data));
  }

  Future<void> _onGetSingleTask(
      GetSingleTask event, Emitter<TaskState> emit) async {}

  Future<void> _onTaskCreated(
      TaskCreated event, Emitter<TaskState> emit) async {
    await saveTaskUseCase(event.params);
  }

  Future<void> _onTaskDeleted(
      TaskDeleted event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastDeletedTask: () => event.taskItem));
    await deleteTaskUseCase(event.taskItem.id);
  }

  Future<void> _onTaskUpdated(
      TaskUpdated event, Emitter<TaskState> emit) async {
    await updateTaskUseCase(
        UpdateTaskParams(id: event.index, taskItem: event.newTaskItem));
  }

  Future<void> _onTaskCompleted(
      TaskCompleted event, Emitter<TaskState> emit) async {
    emit(state.copyWith(
      lastCompletedTask: () => event.taskItem,
    ));
  }

  Future<void> _onTaskUndoChanged(
      TaskUndoChanged event, Emitter<TaskState> emit) async {
    await updateTaskUseCase(
        UpdateTaskParams(id: event.index, taskItem: state.lastCompletedTask!));
    emit(state.copyWith(lastCompletedTask: () => null));
  }

  Future<void> _onTaskLastDumped(
      TaskLastDumped event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastCompletedTask: () => null));
  }

  Future<void> _onTaskClearedAllCompleted(
      TaskClearedAllCompleted event, Emitter<TaskState> emit) async {
    await deleteTasksByCompletedUseCase(categoryId: event.categoryId);
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
    await updateTaskUseCase(UpdateTaskParams(
        id: state.lastUpdatedCategoryTask!.id,
        taskItem: state.lastUpdatedCategoryTask!));
  }

  Future<void> _onTaskUpdatedCategoryDump(
      TaskUpdatedCategoryDump event, Emitter<TaskState> emit) async {
    emit(state.copyWith(lastUpdatedCategoryTask: () => null));
  }

  Future<void> _onTasksDeletedByCategory(
      TasksDeletedByCategory event, Emitter<TaskState> emit) async {
    await deleteTasksByCategoryUseCase(categoryId: event.categoryId);
  }

  Future<void> _onReorderTaskPosition(
      ReorderTaskPosition event, Emitter<TaskState> emit) async {
    await reorderTaskListUseCase(ReorderTaskListParams(
        categoryId: event.categoryId, taskItems: event.taskItems));
  }
}
